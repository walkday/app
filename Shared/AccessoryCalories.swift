import SwiftUI
import WidgetKit
import Walker

struct AccessoryCalories: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Accessory Calories", provider: Provider()) { entry in
            Rectangular(entry: entry, series: .calories)
        }
        .configurationDisplayName("Calories")
        .description("Active calories burned")
        .supportedFamilies([.accessoryRectangular])
    }
}
