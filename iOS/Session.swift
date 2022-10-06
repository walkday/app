import SwiftUI
import Charts
import CloudKit
import HealthKit
import Walker
import Archivable

final class Session: ObservableObject, @unchecked Sendable {
    @Published var settings = Settings()
    @Published var stats = false
    @Published var preferences = false
    @Published var goals = false
    @Published var purchased = false
    @Published var celebration = false
    @Published private(set) var walks = [Walk]()
    let color: Color
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.WalkDay")
    let store = Store()
    private var queries = Set<HKQuery>()
    private let health = HKHealthStore()
    private let predicate = HKQuery.predicateForSamples(
        withStart: Calendar.current.startOfDay(
            for: Calendar.current.date(byAdding: .day, value: -13, to: .now) ?? .now),
        end: nil)
    
    init() {
        color = [Color.blue, .purple, .indigo, .pink, .orange, .teal, .mint, .cyan].randomElement()!
        
        cloud
            .map(\.settings)
            .removeDuplicates()
            .assign(to: &$settings)
        
        Task {
            try? await begin()
        }
    }
    
    var available: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    var goal: Bool {
        switch settings.challenge.series {
        case .calories:
            return settings.goal && settings.calories
        case .distance:
            return settings.goal && settings.distance
        case .steps:
            return settings.goal && settings.steps
        }
    }
    
    var percent: Double {
        walks
            .last
            .map {
                settings.challenge.percent(walk: $0)
            }
        ?? 0
    }
    
    func find(location: CGPoint, overlay: ChartProxy, proxy: GeometryProxy) -> Walk? {
        let x = location.x - proxy[overlay.plotAreaFrame].origin.x
        if let date = overlay.value(atX: x) as Date? {
            return walks
                .first {
                    Calendar.current.isDate($0.date, inSameDayAs: date)
                }
            ?? (date < walks.last!.date ? walks.first! : walks.last!)
        }
        return nil
    }
    
    private func begin() async throws {
        guard available else { return }
        
        try await health.requestAuthorization(toShare: [],
                                             read: [HKQuantityType(.stepCount),
                                                    .init(.distanceWalkingRunning),
                                                    .init(.activeEnergyBurned)])
        steps()
        distance()
        calories()
    }
    
    private func steps() {
        let query = make(type: .init(.stepCount))
        
        query.initialResultsHandler = { [weak self] _, results, _ in
            _ = results
                .map { value in
                    self?.add(steps: value)
                }
        }

        query.statisticsUpdateHandler = {  [weak self] _, _, results, _ in
            _ = results
                .map { value in
                    self?.add(steps: value)
                }
        }

        health.execute(query)
        queries.insert(query)
    }
    
    private func distance() {
        let query = make(type: .init(.distanceWalkingRunning))
        
        query.initialResultsHandler = { [weak self] _, results, _ in
            _ = results
                .map { value in
                    self?.add(distance: value)
                }
        }

        query.statisticsUpdateHandler = {  [weak self] _, _, results, _ in
            _ = results
                .map { value in
                    self?.add(distance: value)
                }
        }

        health.execute(query)
        queries.insert(query)
    }
    
    private func calories() {
        let query = make(type: .init(.activeEnergyBurned))
        
        query.initialResultsHandler = { [weak self] _, results, _ in
            _ = results
                .map { value in
                    self?.add(calories: value)
                }
        }

        query.statisticsUpdateHandler = {  [weak self] _, _, results, _ in
            _ = results
                .map { value in
                    self?.add(calories: value)
                }
        }

        health.execute(query)
        queries.insert(query)
    }
    
    private func make(type: HKQuantityType) -> HKStatisticsCollectionQuery {
        .init(
            quantityType: type,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: Calendar.current.startOfDay(for: .now),
            intervalComponents: .init(day: 1))
    }
    
    private func add(steps: HKStatisticsCollection) {
        let steps = steps
            .statistics()
            .reduce(into: [Date : Int]()) { result, statistics in
                result[statistics.startDate] = statistics.sumQuantity()
                    .map {
                        $0.doubleValue(for: .count())
                    }
                    .map(Int.init)
            }
        
        Task {
            await update(steps: steps)
        }
    }
    
    private func add(distance: HKStatisticsCollection) {
        let distance = distance
            .statistics()
            .reduce(into: [Date : Int]()) { result, statistics in
                result[statistics.startDate] = statistics.sumQuantity()
                    .map {
                        $0.doubleValue(for: .meter())
                    }
                    .map(Int.init)
            }
        
        Task {
            await update(distance: distance)
        }
    }
    
    private func add(calories: HKStatisticsCollection) {
        let calories = calories
            .statistics()
            .reduce(into: [Date : Int]()) { result, statistics in
                result[statistics.startDate] = statistics.sumQuantity()
                    .map {
                        $0.doubleValue(for: .largeCalorie())
                    }
                    .map(Int.init)
            }
        
        Task {
            await update(calories: calories)
        }
    }
    
    @MainActor private func update(steps: [Date : Int]) {
        var walks = walks
        
        steps
            .forEach { item in
                if let index = walks.firstIndex(where: { $0.date == item.key }) {
                    walks[index].steps = item.value
                } else {
                    walks.append(.init(date: item.key, steps: item.value))
                }
            }
        
        update(walks: walks)
    }
    
    @MainActor private func update(distance: [Date : Int]) {
        var walks = walks
        
        distance
            .forEach { item in
                if let index = walks.firstIndex(where: { $0.date == item.key }) {
                    walks[index].distance = item.value
                } else {
                    walks.append(.init(date: item.key, distance: item.value))
                }
            }
        
        update(walks: walks)
    }
    
    @MainActor private func update(calories: [Date : Int]) {
        var walks = walks
        
        calories
            .forEach { item in
                if let index = walks.firstIndex(where: { $0.date == item.key }) {
                    walks[index].calories = item.value
                } else {
                    walks.append(.init(date: item.key, calories: item.value))
                }
            }
        
        update(walks: walks)
    }
    
    @MainActor private func update(walks: [Walk]) {
        let walks = Array(walks.sorted().suffix(14))
        
        if self.walks.isEmpty && !walks.isEmpty {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.walks = walks
            }
        } else {
            self.walks = walks
        }
    }
}
