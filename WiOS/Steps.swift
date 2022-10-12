import SwiftUI
import WidgetKit
import Walker

struct Steps: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Steps", provider: Provider.shared) { entry in
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 3) {
                    Text(Series.steps.title)
                        .font(.caption2.weight(.medium))
                    Image(systemName: Series.steps.symbol)
                        .font(.caption2)
                    Spacer()
                }
                .offset(y: 5)
                
                Text(AttributedString.plain(value: entry.walk.steps)
                    .numeric(font: .title3.weight(.semibold).monospacedDigit()))
                .font(.caption.weight(.regular))
                .widgetAccentable()
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            }
        }
        .configurationDisplayName("Steps")
        .description("Steps walked")
        .supportedFamilies([.accessoryRectangular])
    }
}
