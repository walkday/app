import SwiftUI
import WidgetKit

struct Activity: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Progress", provider: Provider()) { entry in
            Tracker.Gauge(percent: entry.percent)
                .foregroundColor(.random)
                .padding(.horizontal, 15)
                .offset(y: 3)
        }
        .configurationDisplayName("Progress")
        .description("Your challenge progress")
        .supportedFamilies([.systemSmall])
    }
}
