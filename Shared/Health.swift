import HealthKit
import Walker

final class Health {
    private var queries = Set<HKQuery>()
    private let store = HKHealthStore()
    
    var available: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    func begin(update: @escaping @Sendable @MainActor ([Date : Int], WritableKeyPath<Walk, Int>) -> Void) async throws {
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
                    await update(values, metric.keyPath)
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

extension WritableKeyPath: @unchecked Sendable {
    
}
