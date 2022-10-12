import SwiftUI
import WidgetKit

struct Circular: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Circular", provider: Provider.shared) { entry in
            Gauge(value: entry.percent) {
                ZStack {
                    Text(verbatim: "%")
                        .font(.caption2.weight(.heavy))
                        .offset(y: 13)
                    Text(min(Int(entry.percent * 100), 100).formatted())
                        .font(.title3.bold().monospacedDigit())
                        .offset(y: -3)
                        .widgetAccentable()
                }
            }
            .gaugeStyle(.accessoryCircularCapacity)
        }
        .configurationDisplayName("Circular")
        .description("Your progress")
        .supportedFamilies([.accessoryCircular])
    }
}
