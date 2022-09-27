import SwiftUI
import Charts
import CloudKit
import Combine
import Walker
import Archivable

final class Session: ObservableObject {
    @Published private(set) var walks = [Walk]()
    @Published private(set) var challenge: Challenge?
    let color: Color
    private var subs = Set<AnyCancellable>()
    private let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.WalkDay")
    
    init() {
        color = [Color.blue, .purple, .indigo, .pink, .orange, .teal, .mint, .cyan].randomElement()!
        
        cloud
            .map(\.preferences)
            .removeDuplicates()
            .sink { [weak self] preferences in
                self?.challenge = preferences.challenge
            }
            .store(in: &subs)
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
}
