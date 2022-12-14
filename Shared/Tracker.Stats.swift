import SwiftUI
import Walker

extension Tracker {
    struct Stats: View {
        let walk: Walk
        let metrics: Settings.Metrics
        
        var body: some View {
            Grid(alignment: .leading, verticalSpacing: 4) {
                GridRow(alignment: .firstTextBaseline) {
                    title(series: .calories, spacer: metrics.distance || metrics.steps)
                    title(series: .distance, spacer: metrics.steps)
                    title(series: .steps, spacer: false)
                }
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(.secondary)
                
                GridRow(alignment: .firstTextBaseline) {
                    series(series: .calories, spacer: metrics.distance || metrics.steps)
                    series(series: .distance, spacer: metrics.steps)
                    series(series: .steps, spacer: false)
                }
                .font(.init(UIFont.systemFont(ofSize: 18, weight: .regular, width: .compressed)))
            }
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
        }
        
        @ViewBuilder private func title(series: Series, spacer: Bool) -> some View {
            if metrics[keyPath: series.metric] {
                Text("\(Text(series.title).font(.init(UIFont.systemFont(ofSize: 15, weight: .regular, width: .condensed)))) \(Image(systemName: series.symbol))")
                
                if spacer {
                    Spacer()
                }
            }
        }
        
        @ViewBuilder private func series(series: Series, spacer: Bool) -> some View {
            if metrics[keyPath: series.metric] {
                Text(series.string(walk: walk)
                    .numeric(font: .init(UIFont.systemFont(ofSize: 28, weight: .semibold, width: .compressed)).monospacedDigit()))
                
                if spacer {
                    Spacer()
                }
            }
        }
    }
}
