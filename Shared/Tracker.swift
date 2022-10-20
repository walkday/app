import SwiftUI
import Walker

struct Tracker: View {
    let walk: Walk
    let percent: Double
    let metrics: Settings.Metrics
    
    var body: some View {
        VStack(spacing: 0) {
            Gauge(percent: percent)
            
            if metrics.content {
                Stats(walk: walk, metrics: metrics)
            }
        }
    }
}
