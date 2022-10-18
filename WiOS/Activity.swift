import SwiftUI
import WidgetKit

struct Activity: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Progress", provider: Provider()) { entry in
            Tracker.Gauge(percent: 0.5)
                .foregroundColor(.random)
                .padding(.horizontal, 23)
                .offset(y: 4)
        }
        .configurationDisplayName("Progress")
        .description("Your challenge progress")
        .supportedFamilies([.systemSmall])
    }
}
