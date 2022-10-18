import SwiftUI
import WidgetKit

struct Steps: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Steps", provider: Provider()) { entry in
            Squared(entry: entry, series: .steps)
        }
        .configurationDisplayName("Steps")
        .description("Steps walked")
        .supportedFamilies([.systemSmall])
    }
}
