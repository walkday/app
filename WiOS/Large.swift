import SwiftUI
import WidgetKit

struct Large: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Large", provider: Provider()) { entry in
            VStack {
                Spacer()
                Tracker(walk: entry.walk, percent: 0.8, metrics: .init())
                    .foregroundColor(.init(.systemBackground))
                    .fixedSize(horizontal: false, vertical: true)
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
        .configurationDisplayName("Everything")
        .description("Challenge progress and metrics for every day")
        .supportedFamilies([.systemLarge, .systemExtraLarge])
    }
}
