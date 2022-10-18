import SwiftUI
import WidgetKit

struct Distance: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Distance", provider: Provider()) { entry in
            Squared(entry: entry, series: .distance)
        }
        .configurationDisplayName("Distance")
        .description("Distance walked")
        .supportedFamilies([.systemSmall])
    }
}
