import SwiftUI
import Walker

extension Tracker {
    struct Gauge: View {
        let percent: Double
        let height: CGFloat
        let font: CGFloat
        
        var body: some View {
            ZStack {
                ZStack {
                    Progress(value: 1)
                        .stroke(.tertiary, style: .init(lineWidth: 5, lineCap: .round))
                    Progress(value: percent)
                        .stroke(Color(.systemBackground), style: .init(lineWidth: 5, lineCap: .round))
                        .animation(.easeInOut(duration: 0.6), value: percent)
                }
                .frame(height: height)
                
                VStack(spacing: 7) {
                    Spacer()
                    Text(min(Int(percent * 100), 100).formatted())
                        .font(.system(size: percent >= 1 ? font - 8 : font, weight: .semibold).monospacedDigit())
                    Text(verbatim: "%")
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundColor(.init(.systemBackground))
                        .padding(.bottom, 7)
                }
            }
        }
    }
}
