import SwiftUI
import Charts
import Walker

final class Session: ObservableObject {
    @Published private(set) var walks = [Walk]()
    @Published private(set) var challenge: Challenge?
    let color: Color
    
    init() {
        color = [Color.blue, .purple, .indigo, .pink, .orange, .teal, .mint, .cyan].randomElement()!
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
