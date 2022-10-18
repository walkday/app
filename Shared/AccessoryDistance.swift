import SwiftUI
import WidgetKit
import Walker

struct AccessoryDistance: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Accessory Distance", provider: Provider()) { entry in
            Rectangular(entry: entry, series: .distance)
        }
        .configurationDisplayName("Accessory Distance")
        .description("Distance walked")
        .supportedFamilies([.accessoryRectangular])
    }
}
