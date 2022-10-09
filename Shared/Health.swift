import HealthKit
import Walker

final class Health {
    private var queries = Set<HKQuery>()
    private let store = HKHealthStore()
    
    var available: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    func begin(read: @escaping @Sendable @MainActor () -> [Walk],
               write: @escaping @Sendable @MainActor ([Walk]) -> Void) async throws {
        
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
            
            let process = { (collection: HKStatisticsCollection?) in
                guard let collection else { return }
                
                let values = collection
                    .statistics()
                    .reduce(into: [:]) { result, statistics in
                        result[statistics.startDate] = statistics.sumQuantity()
                            .map {
                                $0.doubleValue(for: metric.unit)
                            }
                            .map(Int.init)
                    }
                
                Task {
                    var walks = await read()
                    walks.update(items: values, keyPath: metric.keyPath)
                    await write(walks.sorted().suffix(14))
                }
            }
            
            query.initialResultsHandler = { _, results, _ in process(results) }
            query.statisticsUpdateHandler = { _, _, results, _ in process(results) }
            
            store.execute(query)
            queries.insert(query)
        }
    }
    
    private struct Metric: @unchecked Sendable {
        let identifier: HKQuantityTypeIdentifier
        let unit: HKUnit
        let keyPath: WritableKeyPath<Walk, Int>
    }
}
