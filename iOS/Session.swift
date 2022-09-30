import SwiftUI
import Charts
import CloudKit
import HealthKit
import Walker
import Archivable

final class Session: ObservableObject {
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
        
        guard
            HKHealthStore.isHealthDataAvailable(),
            let fortnight = Calendar.current.date(byAdding: .day, value: -13, to: .now)
        else { return }
        
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: fortnight), end: nil)
        
        Task {
            try? await HKHealthStore().requestAuthorization(toShare: [],
                                                            read: [HKQuantityType(.stepCount),
                                                                   .init(.distanceWalkingRunning),
                                                                   .init(.activeEnergyBurned)])
        }
        
        steps(predicate: predicate)
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
    
    private func steps(predicate: NSPredicate) {
        let query = make(type: .init(.stepCount), predicate: predicate)
        
        query.initialResultsHandler = { [weak self] _, results, _ in
            _ = results
                .map { value in
                    DispatchQueue.main.async { [weak self] in
                        self?.add(steps: value)
                    }
                }
        }

        query.statisticsUpdateHandler = {  [weak self] _, _, results, _ in
            _ = results
                .map { value in
                    DispatchQueue.main.async { [weak self] in
//                        self?.add(steps: value)
                    }
                }
        }

        store.execute(query)
        queries.insert(query)
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
        steps
            .statistics()
            .forEach {
                print($0.startDate.formatted())
                print($0.sumQuantity()
                    .map {
                        $0.doubleValue(for: .count())
                    }
                    .map(Int.init))
            }
    }
}
