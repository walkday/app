import SwiftUI
import WidgetKit
import Walker

struct Distance: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Distance", provider: Provider.shared) { entry in
            Rectangular(walk: entry.walk, series: .distance)
        }
        .configurationDisplayName("Distance")
        .description("Distance walked")
        .supportedFamilies([.accessoryRectangular])
    }
}
