import SwiftUI
import Walker

struct Tracker: View {
    let walk: Walk
    let percent: Double
    let metrics: Settings.Metrics
    
    var body: some View {
        VStack(spacing: 0) {
            Gauge(percent: percent, height: 160, font: 60)
                .padding(.top, 10)
            
            Text(caption)
                .font(.callout.weight(.medium))
                .foregroundStyle(.secondary)
                .padding(.bottom, 25)
            
            if metrics.content {
                Stats(walk: walk, metrics: metrics)
                    .padding(.bottom, 20)
            }
        }
    }
    
    private var caption: String {
        switch percent {
        case 1...:
            return "Challenge completed!"
        case 0.7 ..< 1:
            return "You are doing great!"
        case 0 ... 0.3:
            return "You have this, keep walking"
        default:
            return "Half way there"
        }
    }
}
