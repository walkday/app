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
        
        let date = Calendar.current.startOfDay(for: fortnight)
        let predicate = HKQuery.predicateForSamples(withStart: date, end: nil)
        
        Task {
            try? await HKHealthStore().requestAuthorization(toShare: [],
                                                            read: [HKQuantityType(.stepCount),
                                                                   .init(.distanceWalkingRunning),
                                                                   .init(.activeEnergyBurned)])
        }
        
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
    
    private func make(type: HKQuantityType, predicate: NSPredicate) -> HKStatisticsCollectionQuery {
        .init(
            quantityType: type,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: .now,
            intervalComponents: .init(minute: 1))
    }
}
