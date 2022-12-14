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
                            .foregroundStyle(.tertiary)
                    } else {
                        Text(min(Int(entry.percent * 100), 100).formatted())
                            #if os(iOS)
                                .font(.init(UIFont.systemFont(ofSize: 28, weight: .bold, width: .condensed)).monospacedDigit())
                            #else
                                .font(.system(size: 28, weight: .semibold).monospacedDigit())
                            #endif
                            .offset(y: -4)
                    }
                }
            }
            .gaugeStyle(.accessoryCircularCapacity)
        }
        .configurationDisplayName("Progress")
        .description("Your challenge progress")
        .supportedFamilies([.accessoryCircular])
    }
}
