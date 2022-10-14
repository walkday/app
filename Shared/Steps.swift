import SwiftUI
import WidgetKit
import Walker

struct Steps: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Steps", provider: Provider.shared) { entry in
            Rectangular(walk: entry.walk, series: .steps)
        }
        .configurationDisplayName("Steps")
        .description("Steps walked")
        .supportedFamilies([.accessoryRectangular])
    }
}
