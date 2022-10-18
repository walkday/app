import SwiftUI
import WidgetKit

struct Activity: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Progress", provider: Provider()) { entry in
            Tracker.Gauge(percent: 0.5)
                .foregroundColor(.secondary)
                .padding(.horizontal, 28)
                .offset(y: 4)
                .background {
                    Color(.tertiarySystemBackground)
                }
        }
        .configurationDisplayName("Progress")
        .description("Your challenge progress")
        .supportedFamilies([.systemSmall])
    }
}
