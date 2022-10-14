import SwiftUI
import Walker

struct Rectangular: View {
    let walk: Walk
    let series: Series
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 3) {
                Text(series.title)
                    .font(.caption.weight(.medium))
                Image(systemName: series.symbol)
                    .font(.caption)
                Spacer()
            }
            .widgetAccentable()
            .offset(y: 5)
            
            Text(series.string(walk: walk)
                .numeric(font: .title3.weight(.semibold).monospacedDigit()))
            .font(.caption.weight(.regular))
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
        }
        .privacySensitive(false)
    }
}
