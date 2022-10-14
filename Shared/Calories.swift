import SwiftUI
import WidgetKit
import Walker

struct Calories: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Calories", provider: Provider.shared) { entry in
            Rectangular(walk: entry.walk, series: .calories)
        }
        .configurationDisplayName("Calories")
        .description("Active calories burned")
        .supportedFamilies([.accessoryRectangular])
    }
}
