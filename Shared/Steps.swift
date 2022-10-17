import SwiftUI
import WidgetKit
import Walker

struct Steps: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Steps", provider: Provider()) { entry in
            Rectangular(entry: entry, series: .steps)
        }
        .configurationDisplayName("Steps")
        .description("Steps walked")
        .supportedFamilies([.accessoryRectangular])
    }
}
