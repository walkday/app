import SwiftUI
import Charts
import CloudKit
import HealthKit
import Walker
import Archivable

final class Session: ObservableObject, @unchecked Sendable {
    @Published var preferences = Walker.Preferences()
    @Published private(set) var walks = [Walk]()
    let color: Color
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.WalkDay")
    private var queries = Set<HKQuery>()
    private let store = HKHealthStore()
    
    init() {
        color = [Color.blue, .purple, .indigo, .pink, .orange, .teal, .mint, .cyan].randomElement()!
        
        cloud
            .map(\.preferences)
            .removeDuplicates()
            .assign(to: &$preferences)
        
        Task {
            try? await begin()
        }
    }
    
    func find(location: CGPoint, overlay: ChartProxy, proxy: GeometryProxy) -> Walk? {
        let x = location.x - proxy[overlay.plotAreaFrame].origin.x
        if let date = overlay.value(atX: x) as Date? {
            return walks
                .first {
                    Calendar.current.isDate($0.date, inSameDayAs: date)
                }
            ?? (x <= 0 ? walks.first : walks.last)
        }
        return nil
    }
    
    private func begin() async throws {
        guard
            HKHealthStore.isHealthDataAvailable(),
            let fortnight = Calendar.current.date(byAdding: .day, value: -13, to: .now)
        else { return }
        
        let initial = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: fortnight), end: nil)
        let update = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: .now), end: nil)
        
        try await store.requestAuthorization(toShare: [],
                                             read: [HKQuantityType(.stepCount),
                                                    .init(.distanceWalkingRunning),
                                                    .init(.activeEnergyBurned)])
        
        steps(initialPredicate: initial, updatePredicate: update)
    }
    
    private func steps(initialPredicate: NSPredicate, updatePredicate: NSPredicate) {
        let initial = make(type: .init(.stepCount), predicate: initialPredicate)
        let update = make(type: .init(.stepCount), predicate: updatePredicate)
        
        initial.initialResultsHandler = { [weak self] _, results, _ in
            _ = results
                .map { value in
                    self?.add(steps: value)
                }
        }

        update.initialResultsHandler = initial.initialResultsHandler
        update.statisticsUpdateHandler = {  [weak self] _, _, results, _ in
            _ = results
                .map { value in
                    self?.add(steps: value)
                }
        }

        store.execute(initial)
        store.execute(update)
        queries.insert(initial)
        queries.insert(update)
    }
    
    private func make(type: HKQuantityType, predicate: NSPredicate) -> HKStatisticsCollectionQuery {
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
        
        walks = walks.sorted().suffix(14)
        self.walks = walks
    }
}
