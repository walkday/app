import SwiftUI
import WidgetKit

struct Circular: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Circular", provider: Provider()) { entry in
            Gauge(value: entry.percent) {
                VStack {
                    Text(min(Int(entry.percent * 100), 100).formatted())
                        .font(.body.bold().monospacedDigit())
                        .widgetAccentable()
                    Text(verbatim: "%")
                        .font(.caption.weight(.heavy))
                }
            }
            .gaugeStyle(.accessoryCircularCapacity)
        }
        .configurationDisplayName("Challenge")
        .description("Your challenge progress for every day")
        .supportedFamilies([.accessoryCircular])
    }
}
