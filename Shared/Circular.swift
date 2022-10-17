import SwiftUI
import WidgetKit

struct Circular: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Circular", provider: Provider()) { entry in
            Gauge(value: entry.percent) {
                ZStack {
                    Text(verbatim: "%")
                        .font(.system(size: 13, weight: .semibold))
                        .offset(y: 12)
                        .widgetAccentable()
                    if entry.walk == nil {
                        Capsule()
                            .frame(width: 30, height: 5)
                    } else {
                        Text(min(Int(entry.percent * 100), 100).formatted())
                            .font(.system(size: 36, weight: .bold).monospacedDigit())
                            .offset(y: -4)
                    }
                }
            }
            .gaugeStyle(.accessoryCircularCapacity)
        }
        .configurationDisplayName("Circular")
        .description("Your progress")
        .supportedFamilies([.accessoryCircular])
    }
}
