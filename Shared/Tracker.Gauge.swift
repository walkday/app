import SwiftUI
import Walker

extension Tracker {
    struct Gauge: View {
        let percent: Double
        
        var body: some View {
            ZStack {
                Text(verbatim: "%")
                    .font(.system(size: 18, weight: .heavy))
                    .padding(.top, 75)
                
                ZStack {
                    Progress(value: 1)
                        .stroke(.tertiary, style: .init(lineWidth: 10, lineCap: .round))
                    Progress(value: percent)
                        .stroke(style: .init(lineWidth: 12, lineCap: .round))
                        .animation(.easeInOut(duration: 0.6), value: percent)
                }
                
                Text(min(Int(percent * 100), 100).formatted())
                    .font(.init(UIFont.systemFont(ofSize: 60, weight: .semibold, width: .compressed)).monospacedDigit())
                    .minimumScaleFactor(0.1)
                    .padding(.horizontal, 28)
                    .offset(y: -1)
                    .lineLimit(1)
            }
        }
    }
}
