import SwiftUI
import Charts
import CloudKit
import Walker
import Archivable

final class Session: ObservableObject {
    @Published private(set) var walks = [Walk]()
    @Published private(set) var challenge: Challenge?
    let color: Color
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.WalkDay")
    
    init() {
        color = [Color.blue, .purple, .indigo, .pink, .orange, .teal, .mint, .cyan].randomElement()!
        
        cloud
            .combineLatest($provider
                .compactMap {
                    $0
                }) { model, provider in
                model.items(provider: provider)
            }
            .removeDuplicates()
            .combineLatest($showing, $search) { items, showing, search in
                items
                    .filter { element in
                        switch showing {
                        case 0:
                            return true
                        case 1:
                            return element.status == .new
                        default:
                            return element.status == .bookmarked
                        }
                    }
                    .filter(search: search)
                    .sorted()
            }
            .removeDuplicates()
            .sink {
                
            }
            .store(in: &Substring)
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
