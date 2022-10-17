import SwiftUI
import WidgetKit
import Walker

struct Distance: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Distance", provider: Provider()) { entry in
            Rectangular(entry: entry, series: .distance)
        }
        .configurationDisplayName("Distance")
        .description("Distance walked")
        .supportedFamilies([.accessoryRectangular])
    }
}
