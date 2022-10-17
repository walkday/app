import SwiftUI
import WidgetKit
import Walker

struct Calories: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Calories", provider: Provider()) { entry in
            Rectangular(entry: entry, series: .calories)
        }
        .configurationDisplayName("Calories")
        .description("Active calories burned")
        .supportedFamilies([.accessoryRectangular])
    }
}
