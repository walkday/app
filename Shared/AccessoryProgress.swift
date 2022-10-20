import SwiftUI
import WidgetKit

struct AccessoryProgress: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Accesory Progress", provider: Provider()) { entry in
            Gauge(value: entry.percent) {
                ZStack {
                    Text(verbatim: "%")
                        .font(.system(size: 12, weight: .semibold))
                        .offset(y: 12)
                        .widgetAccentable()
                    if entry.walk == nil {
                        Capsule()
                            .frame(width: 24, height: 3)
                            .offset(y: -2)
                            .widgetAccentable()
                    } else {
                        Text(min(Int(entry.percent * 100), 100).formatted())
                            .font(.system(size: 30, weight: .bold).monospacedDigit())
                            .offset(y: -4)
                    }
                }
            }
            .gaugeStyle(.accessoryCircularCapacity)
        }
        .configurationDisplayName("Accessory Progress")
        .description("Your challenge progress")
        .supportedFamilies([.accessoryCircular])
    }
}