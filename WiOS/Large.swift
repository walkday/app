import SwiftUI
import WidgetKit

struct Large: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Large", provider: Provider()) { entry in
            Tracker(walk: entry.walk ?? .init(), percent: entry.percent, metrics: .init())
                .foregroundColor(.init(.systemBackground))
                .padding(.bottom, 20)
                .padding([.top, .leading, .trailing], 25)
                .background(content: Background.init)
        }
        .configurationDisplayName("Large")
        .description("Progress and metrics")
        .supportedFamilies([.systemLarge, .systemExtraLarge])
    }
}
