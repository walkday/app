import SwiftUI
import WidgetKit
import Walker

struct Distance: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Distance", provider: Provider.shared) { entry in
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 3) {
                    Image(systemName: Series.distance.symbol)
                        .font(.caption)
                    Text(Series.distance.title)
                        .font(.caption.weight(.medium))
                    Spacer()
                }
                .padding(.top, 4)
                
                Text(Series.distance.string(from: entry.walk.distance)
                    .numeric(font: .title3.weight(.semibold).monospacedDigit(),
                             color: .primary))
                .font(.caption.weight(.regular))
                .widgetAccentable()
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            }
        }
        .configurationDisplayName("Distance")
        .description("Distance walked")
        .supportedFamilies([.accessoryRectangular])
    }
}
