import SwiftUI
import WidgetKit

struct Medium: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Medium", provider: Provider()) { entry in
            Tracker.Stats(walk: entry.walk, metrics: .init())
                .foregroundColor(.init(.systemBackground))
                .padding(.horizontal, 30)
                .offset(y: 5)
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
                .background(content: Background.init)
        }
        .configurationDisplayName("Medium")
        .description("Walking metrics")
        .supportedFamilies([.systemMedium])
    }
}
