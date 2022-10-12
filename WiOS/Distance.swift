import SwiftUI
import WidgetKit
import Walker

struct Distance: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Distance", provider: Provider.shared) { entry in
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 3) {
                    Text(Series.distance.title)
                        .font(.caption.weight(.medium))
                    Image(systemName: Series.distance.symbol)
                        .font(.caption)
                    Spacer()
                }
                .offset(y: 5)
                
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
