import SwiftUI
import WidgetKit

struct Circular: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Circular", provider: Provider.shared) { entry in
            Gauge(value: entry.percent) {
                ZStack {
                    Text(verbatim: "%")
                        .font(.system(size: 11, weight: .medium))
                        .offset(y: 12)
                        .widgetAccentable()
                    Text(min(Int(entry.percent * 100), 100).formatted())
                        .font(.system(size: 30, weight: .bold).monospacedDigit())
                        .offset(y: -2)
                }
            }
            .gaugeStyle(.accessoryCircularCapacity)
        }
        .configurationDisplayName("Circular")
        .description("Your progress")
        .supportedFamilies([.accessoryCircular])
    }
}
