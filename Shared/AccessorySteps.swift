import SwiftUI
import WidgetKit
import Walker

struct AccessorySteps: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Accessory Steps", provider: Provider()) { entry in
            Rectangular(entry: entry, series: .steps)
        }
        .configurationDisplayName("Accessory Steps")
        .description("Steps walked")
        .supportedFamilies([.accessoryRectangular])
    }
}
