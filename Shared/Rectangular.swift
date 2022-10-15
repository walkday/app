import SwiftUI
import Walker

struct Rectangular: View {
    let walk: Walk
    let series: Series
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 3) {
                Text(series.title)
                    .font(.system(size: 14, weight: .medium))
                Image(systemName: series.symbol)
                    .font(.system(size: 11, weight: .regular))
                Spacer()
            }
            .widgetAccentable()
            
            Text(series.string(walk: walk)
                .numeric(font: .system(size: 32, weight: .semibold).monospacedDigit()))
            .font(.system(size: 18, weight: .regular))
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
        }
    }
}
