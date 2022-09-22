import SwiftUI
import Charts

final class Session: ObservableObject {
    @Published private(set) var walks: [Walk]
    @Published private(set) var challenge: Challenge
    let color: Color
    
    var week: [Walk] {
        walks.suffix(7)
    }
    
    init() {
        walks = (1 ... 300)
            .map {
                .init(date: Calendar.current.date(byAdding: .day, value: -($0), to: .now)!,
                      steps: .random(in: 3000 ..< 7000),
                      calories: .random(in: 500 ..< 3000),
                      distance: .random(in: 2000 ..< 5000))
            }
            .reversed()
        
        challenge = .init(value: 6000, series: .steps)
        
        color = [Color.blue, .purple, .indigo, .pink, .orange, .teal, .mint, .cyan].randomElement()!
    }
    
    func find(location: CGPoint, overlay: ChartProxy, proxy: GeometryProxy) -> Walk? {
        let x = location.x - proxy[overlay.plotAreaFrame].origin.x
        if let date = overlay.value(atX: x) as Date? {
            return week
                .first {
                    Calendar.current.isDate($0.date, inSameDayAs: date)
                }
        }
        return nil
    }
}
