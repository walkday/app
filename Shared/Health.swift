import HealthKit

struct Health {
    private let queries: Set<HKQuery>
    private let store = HKHealthStore()
    
    init?() async throws {
        guard
            HKHealthStore.isHealthDataAvailable(),
            let fortnight = Calendar.current.date(byAdding: .day, value: -14, to: .now)
        else { return nil }
        var queries = Set<HKQuery>()
        let date = Calendar.current.startOfDay(for: fortnight)
        let predicate = HKQuery.predicateForSamples(withStart: date, end: nil)
        
        print(date.formatted())
        
        try await store.requestAuthorization(toShare: [],
                                             read: [HKQuantityType(.stepCount),
                                                    .init(.distanceWalkingRunning),
                                                    .init(.activeEnergyBurned)])
        
        self.queries = queries
    }
    
    
    /*
    
    
    
    

    @MainActor func start(date: Date) async {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        Challenge
            .steps
            .quantity
            .map {
                query(start: date, quantity: $0)
            }
            .map {
                $0
                    .initialResultsHandler = { [weak self] _, results, _ in
                        _ = results
                            .map { value in
                                DispatchQueue.main.async { [weak self] in
                                    self?.add(steps: value)
                                }
                            }
                    }

                $0
                    .statisticsUpdateHandler = {  [weak self] _, _, results, _ in
                        _ = results
                            .map { value in
                                DispatchQueue.main.async { [weak self] in
                                    self?.add(steps: value)
                                }
                            }
                    }

                store.execute($0)
                queries.insert($0)
            }

        Challenge
            .metres
            .quantity
            .map {
                query(start: date, quantity: $0)
            }
            .map {
                $0
                    .initialResultsHandler = { [weak self] _, results, _ in
                        _ = results
                            .map { value in
                                DispatchQueue.main.async { [weak self] in
                                    self?.add(metres: value)
                                }
                            }
                    }

                $0
                    .statisticsUpdateHandler = { [weak self] _, _, results, _ in
                        _ = results
                            .map { value in
                                DispatchQueue.main.async { [weak self] in
                                    self?.add(metres: value)
                                }
                            }
                    }

                store.execute($0)
                queries.insert($0)
            }

        Challenge
            .calories
            .quantity
            .map {
                query(start: date, quantity: $0)
            }
            .map {
                $0
                    .initialResultsHandler = { [weak self] _, results, _ in
                        _ = results
                            .map { value in
                                DispatchQueue.main.async { [weak self] in
                                    self?.add(calories: value)
                                }
                            }
                    }

                $0
                    .statisticsUpdateHandler = { [weak self] _, _, results, _ in
                        _ = results
                            .map { value in
                                DispatchQueue.main.async { [weak self] in
                                    self?.add(calories: value)
                                }
                            }
                    }

                store.execute($0)
                queries.insert($0)
            }
    }

    @MainActor func clear() async {
        queries.forEach(store.stop)
        queries = []
    }
    
#endif
    
    @MainActor private func add(steps: HKStatisticsCollection) {
        self.steps = steps
            .statistics()
            .compactMap {
                $0.sumQuantity()
                    .map {
                        $0.doubleValue(for: .count())
                    }
                    .map(Int.init)
            }
            .reduce(0, +)
    }

    @MainActor private func add(metres: HKStatisticsCollection) {
        self.metres = metres
            .statistics()
            .compactMap {
                $0.sumQuantity()
                    .map {
                        $0.doubleValue(for: .meter())
                    }
                    .map(Int.init)
            }
            .reduce(0, +)
    }

    @MainActor private func add(calories: HKStatisticsCollection) {
        self.calories = calories
            .statistics()
            .compactMap {
                $0.sumQuantity()
                    .map {
                        $0.doubleValue(for: .smallCalorie())
                    }
                    .map(Int.init)
            }
            .reduce(0, +)
    }

    @MainActor private func query(start: Date, quantity: HKQuantityType) -> HKStatisticsCollectionQuery {
        .init(
            quantityType: quantity,
            quantitySamplePredicate: HKQuery.predicateForSamples(withStart: start, end: nil),
            options: .cumulativeSum,
            anchorDate: start,
            intervalComponents: .init(second: 10))
    }
    */
}

private extension HKStatisticsCollectionQuery {
    class func make(type: HKQuantityType, predicate: NSPredicate) -> Self {
        .init(
            quantityType: type,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: .now,
            intervalComponents: .init(minute: 1))
    }
}