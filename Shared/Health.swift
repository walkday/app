import HealthKit
import Walker

final class Health {
    private var queries = Set<HKQuery>()
    private static let store = HKHealthStore()
    
    
    private static var queries = Set<HKQuery>()
    private var counter = 0
    
    var available: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    func today(previous: Walk) async -> Walk {
        let date = Calendar.current.startOfDay(for: .now)
        self.counter += 1
        let counter = self.counter
        return await withTaskGroup(of: (series: Series, value: Int).self) { group -> Walk in
            
            Series.allCases.forEach { series in
                group
                    .addTask {
                        let value = await withUnsafeContinuation { continuation in
                            let query = Self.query(series: series, date: date)
                            
                            query.initialResultsHandler = { _, results, _ in
                                continuation.resume(returning: results?
                                    .statistics()
                                    .last?
                                    .sumQuantity()
                                    .map {
                                        $0.doubleValue(for: series.unit)
                                    }
                                    .map(Int.init) ?? counter)
                            }
                            
                            Self.queries.insert(query)
                            Self.store.execute(query)
                        }
                        
                        return (series: series, value: value)
                    }
            }
            
            return await group
                .reduce(into: Walk(date: date)) { walk, task in
                    walk[keyPath: task.series.keyPath] = task.value
                }
        }
    }
    
    func auth() async throws {
        guard available else { return }
        
        var requests = Set<HKQuantityType>()
        
        for type in Series.allCases.map(\.identifier).map(HKQuantityType.init) {
            if try await Self.store.statusForAuthorizationRequest(toShare: [], read: [type]) != .unnecessary {
                requests.insert(type)
            }
        }
        
        if !requests.isEmpty {
            try await Self.store.requestAuthorization(toShare: [], read: requests)
        }
    }
    
    func begin(update: @escaping @Sendable @MainActor ([Date : Int], WritableKeyPath<Walk, Int>) -> Void) async {
        guard available else { return }
        
        let date = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -13, to: .now)!)
        
        Series.allCases.forEach { series in
            let query = Self.query(series: series, date: date)
            
            let process = { (collection: HKStatisticsCollection?) in
                guard let collection else { return }
                let values = collection
                    .statistics()
                    .reduce(into: [:]) { result, statistics in
                        result[statistics.startDate] = statistics.sumQuantity()
                            .map {
                                $0.doubleValue(for: series.unit)
                            }
                            .map(Int.init)
                    }
                
                Task {
                    await update(values, series.keyPath)
                }
            }
            
            query.initialResultsHandler = { _, results, _ in process(results) }
            query.statisticsUpdateHandler = { _, _, results, _ in process(results) }
            
            Self.store.execute(query)
            queries.insert(query)
        }
    }
    
    private static func query(series: Series, date: Date) -> HKStatisticsCollectionQuery {
        .init(
            quantityType: .init(series.identifier),
            quantitySamplePredicate: HKQuery.predicateForSamples(withStart: date, end: nil),
            options: .cumulativeSum,
            anchorDate: date,
            intervalComponents: .init(day: 1))
    }
}

extension WritableKeyPath: @unchecked Sendable {
    
}
