import SwiftUI
import WidgetKit

struct Small: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Small", provider: Provider()) { entry in
            VStack {
                Spacer()
                Tracker.Gauge(percent: 0.8)
                    .foregroundColor(.init(.systemBackground))
                    .frame(height: 120)
                Spacer()
            }
            .background {
                LinearGradient(colors: [entry.color,
                                        entry.color.opacity(0.6)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea(edges: .all)
            }
        }
        .configurationDisplayName("Challenge")
        .description("Your challenge progress for every day")
        .supportedFamilies([.systemSmall])
    }
}
