import SwiftUI
import WidgetKit

struct Small: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Small", provider: Provider.shared) { entry in
            Tracker.Gauge(percent: entry.percent)
                .foregroundColor(.init(.systemBackground))
                .padding(.horizontal, 18)
                .offset(y: 5)
                .background(content: Background.init)
        }
        .configurationDisplayName("Small")
        .description("Your progress")
        .supportedFamilies([.systemSmall])
    }
}
