import HealthKit
import Walker

final class Health {
    typealias Read = @Sendable @MainActor () -> [Walk]
    typealias Write = @Sendable @MainActor ([Walk]) -> Void
    
    private var queries = Set<HKQuery>()
    private let store = HKHealthStore()
    
    var available: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    func begin(read: @escaping Read, write: @escaping Write) async throws {
        guard available else { return }
        
        try await store
            .requestAuthorization(toShare: [],
                                  read: [HKQuantityType(.stepCount),
                                         .init(.distanceWalkingRunning),
                                         .init(.activeEnergyBurned)])
        
        let predicate = HKQuery.predicateForSamples(
            withStart: Calendar.current.startOfDay(
                for: Calendar.current.date(byAdding: .day, value: -13, to: .now) ?? .now),
            end: nil)
        
        [Metric(identifier: .stepCount, unit: .count(), keyPath: \.steps),
         .init(identifier: .distanceWalkingRunning, unit: .meter(), keyPath: \.distance),
         .init(identifier: .activeEnergyBurned, unit: .largeCalorie(), keyPath: \.calories)
        ].forEach { metric in
            let query = HKStatisticsCollectionQuery(
                quantityType: .init(metric.identifier),
                quantitySamplePredicate: predicate,
                options: .cumulativeSum,
                anchorDate: Calendar.current.startOfDay(for: .now),
                intervalComponents: .init(day: 1))
            
            query.initialResultsHandler = { _, results, _ in
                guard let values = results?.values(unit: metric.unit) else { return }
                Task {
                    await metric.add(values: values, read: read, write: write)
                }
            }
            
            query.statisticsUpdateHandler = { _, _, results, _ in
                guard let values = results?.values(unit: metric.unit) else { return }
                Task {
                    await metric.add(values: values, read: read, write: write)
                }
            }
            
            store.execute(query)
            queries.insert(query)
        }
    }
    
    private struct Metric: @unchecked Sendable {
        let identifier: HKQuantityTypeIdentifier
        let unit: HKUnit
        let keyPath: WritableKeyPath<Walk, Int>
        
        @MainActor func add(values: [Date : Int], read: @escaping Health.Read, write: @escaping Health.Write) async {
            var walks = read()
            walks.update(items: values, keyPath: keyPath)
            write(walks.sorted().suffix(14))
        }
    }
}

private extension HKStatisticsCollection {
    func values(unit: HKUnit) -> [Date : Int] {
        statistics()
            .reduce(into: [:]) { result, statistics in
                result[statistics.startDate] = statistics.sumQuantity()
                    .map {
                        $0.doubleValue(for: unit)
                    }
                    .map(Int.init)
            }
    }
}
