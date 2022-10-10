import SwiftUI
import WidgetKit

struct Medium: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Medium", provider: Provider()) { entry in
            VStack {
                Spacer()
                Tracker.Stats(walk: entry.walk, metrics: .init())
                    .foregroundColor(.init(.systemBackground))
                Spacer()
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
            .background {
                LinearGradient(colors: [entry.color,
                                        entry.color.opacity(0.6)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea(edges: .all)
            }
        }
        .configurationDisplayName("Metrics")
        .description("Your walking metrics for every day")
        .supportedFamilies([.systemMedium])
    }
}
