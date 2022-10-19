import SwiftUI
import Walker

struct Rectangular: View {
    let entry: Entry
    let series: Series
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 3) {
                Text(series.title)
                    .font(.system(size: 15, weight: .medium))
                Image(systemName: series.symbol)
                    .font(.system(size: 12, weight: .regular))
                Spacer()
            }
            .widgetAccentable()
            
            if let walk = entry.walk {
                Text(series.string(walk: walk)
                    .numeric(font: .system(size: 32, weight: .semibold).monospacedDigit()))
                .font(.system(size: 19, weight: .medium))
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            } else {
                HStack {
                    Capsule()
                        .frame(width: 22, height: 3)
                    Capsule()
                        .frame(width: 22, height: 3)
                    Spacer()
                }
                .padding(.top, 4)
                .widgetAccentable()
            }
        }
    }
}
