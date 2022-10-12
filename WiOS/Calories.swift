import SwiftUI
import WidgetKit
import Walker

struct Calories: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Calories", provider: Provider.shared) { entry in
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 3) {
                    Text(Series.calories.title)
                        .font(.caption.weight(.medium))
                    Image(systemName: Series.calories.symbol)
                        .font(.caption)
                    Spacer()
                }
                .offset(y: 5)
                
                Text(Series.calories.string(from: entry.walk.calories)
                    .numeric(font: .title3.weight(.semibold).monospacedDigit(),
                             color: .primary))
                .font(.caption.weight(.regular))
                .widgetAccentable()
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            }
        }
        .configurationDisplayName("Calories")
        .description("Active calories burned")
        .supportedFamilies([.accessoryRectangular])
    }
}
