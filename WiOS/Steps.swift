import SwiftUI
import WidgetKit
import Walker

struct Steps: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Steps", provider: Provider.shared) { entry in
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 3) {
                    Image(systemName: Series.steps.symbol)
                        .font(.caption)
                    Text(Series.steps.title)
                        .font(.caption.weight(.medium))
                    Spacer()
                }
                .padding(.top, 4)
                
                Text(AttributedString.plain(value: entry.walk.steps)
                    .numeric(font: .title3.weight(.semibold).monospacedDigit(),
                             color: .primary))
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
