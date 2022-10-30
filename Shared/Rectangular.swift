import SwiftUI
import Walker

struct Rectangular: View {
    let entry: Entry
    let series: Series
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 14) {
                Text(series.title)
                    .font(.system(size: 16, weight: .medium))
                Image(systemName: series.symbol)
                    .font(.system(size: 13, weight: .regular))
                Spacer()
            }
            .widgetAccentable()
            
            if let walk = entry.walk {
                Text(series.string(walk: walk)
                     #if os(iOS)
                    .numeric(font: .init(UIFont.systemFont(ofSize: 28, weight: .bold, width: .condensed)).monospacedDigit())
                     #else
                    .numeric(font: .system(size: 28, weight: .semibold).monospacedDigit())
                     #endif
                )
                #if os(iOS)
                    .font(.init(UIFont.systemFont(ofSize: 22, weight: .medium, width: .condensed)))
                #else
                    .font(.system(size: 22, weight: .regular))
                #endif
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
                .foregroundStyle(.tertiary)
            }
        }
    }
}
