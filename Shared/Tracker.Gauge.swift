import SwiftUI
import Walker

extension Tracker {
    struct Gauge: View {
        let percent: Double
        
        var body: some View {
            ZStack {
                Text(verbatim: "%")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(.init(.systemBackground))
                    .padding(.top, 80)
                
                ZStack {
                    Progress(value: 1)
                        .stroke(.tertiary, style: .init(lineWidth: 10, lineCap: .round))
                    Progress(value: percent)
                        .stroke(Color(.systemBackground), style: .init(lineWidth: 12, lineCap: .round))
                        .animation(.easeInOut(duration: 0.6), value: percent)
                }
                
                Text(min(Int(percent * 100), 100).formatted())
                    .font(.system(size: 60, weight: .semibold).monospacedDigit())
                    .minimumScaleFactor(0.1)
                    .padding(.horizontal, 28)
                    .lineLimit(1)
            }
        }
    }
}
