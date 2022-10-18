import SwiftUI
import WidgetKit

struct Calories: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Calories", provider: Provider()) { entry in
            Squared(entry: entry, series: .calories)
        }
        .configurationDisplayName("Calories")
        .description("Active calories burned")
        .supportedFamilies([.systemSmall])
    }
}
