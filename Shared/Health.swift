import HealthKit
import Walker

final class Health {
    private var queries = Set<HKQuery>()
    private let store = HKHealthStore()
    
    var available: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    static var today: Walk {
        get async throws {
            let store = HKHealthStore()
            let date = Calendar.current.startOfDay(for: .now)
            
            return try await withThrowingTaskGroup(of: (series: Series, value: Int).self) { group -> Walk in
                for series in Series.allCases {
                    
                    guard
                        HKHealthStore.isHealthDataAvailable(),
                        let request = try? await store.statusForAuthorizationRequest(
                            toShare: [],
                            read: [series.quantity]),
                        request == .unnecessary
                    else { continue }
                    
                    group
                        .addTask {
                            let value: Int = try await withUnsafeThrowingContinuation { continuation in
                                let query = HKStatisticsCollectionQuery(
                                    quantityType: .init(series.identifier),
                                    quantitySamplePredicate: HKQuery.predicateForSamples(withStart: date, end: nil),
                                    options: .cumulativeSum,
                                    anchorDate: date,
                                    intervalComponents: .init(day: 1))

                                query.initialResultsHandler = { _, results, error in
                                    if let error {
                                        continuation.resume(throwing: error)
                                        return
                                    }
                                    
                                    guard
                                        let results = results
                                    else {
                                        continuation.resume(throwing: NSError(domain: "No results", code: 0))
                                        return
                                    }
                                    
                                    continuation.resume(returning: results
                                        .statistics()
                                        .reduce(into: 0) { result, statistics in
                                            guard
                                                Calendar.current.isDateInToday(statistics.startDate)
                                            else { return }
                                            
                                            result += statistics.sumQuantity()
                                                .map {
                                                    $0.doubleValue(for: series.unit)
                                                }
                                                .map(Int.init) ?? 0
                                        })
                                }

                                store.execute(query)
                            }

                            return (series: series, value: value)
                        }
                }
                
                return try await group
                    .reduce(into: Walk()) { walk, task in
                        walk[keyPath: task.series.keyPath] = task.value
                    }
            }
        }
    }
    
    func auth() async throws {
        guard available else { return }
        
        var requests = Set<HKQuantityType>()
        
        for type in Series.allCases.map(\.quantity) {
            if try await store.statusForAuthorizationRequest(toShare: [], read: [type]) != .unnecessary {
                requests.insert(type)
            }
        }
        
        if !requests.isEmpty {
            try await store.requestAuthorization(toShare: [], read: requests)
        }
    }
    
    @MainActor func begin(update: @escaping @Sendable @MainActor ([Date : Int], WritableKeyPath<Walk, Int>) -> Void,
                          failed: @escaping @MainActor () -> Void) {
        guard available else { return }
        
        let date = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -13, to: .now)!)
        
        Series.allCases.forEach { series in
            let query = HKStatisticsCollectionQuery(
                quantityType: .init(series.identifier),
                quantitySamplePredicate: HKQuery.predicateForSamples(withStart: date, end: nil),
                options: .cumulativeSum,
                anchorDate: date,
                intervalComponents: .init(day: 1))
            
            let process = { (collection: HKStatisticsCollection) in
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
                    await MainActor
                        .run {
                            update(values, series.keyPath)
                        }
                }
            }
            
            query.initialResultsHandler = { _, results, error in
                guard error == nil, let results else {
                    Task {
                        await MainActor
                            .run {
                                failed()
                            }
                    }
                    return
                }
                
                process(results)
            }
            
            query.statisticsUpdateHandler = { _, _, results, error in
                guard error == nil, let results else {
                    Task {
                        await MainActor
                            .run {
                                failed()
                            }
                    }
                    return
                }
                
                process(results)
            }
            
            store.execute(query)
            queries.insert(query)
        }
    }
}

extension WritableKeyPath: @unchecked Sendable {
    
}
