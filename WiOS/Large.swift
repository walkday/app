import SwiftUI
import WidgetKit

struct Large: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Large", provider: Provider.shared) { entry in
            Tracker(walk: entry.walk, percent: entry.percent, metrics: .init())
                .foregroundColor(.init(.systemBackground))
                .padding(.horizontal, 35)
                .padding(.bottom, 20)
                .padding(.top, 25)
                .background(content: Background.init)
        }
        .configurationDisplayName("Large")
        .description("Progress and metrics")
        .supportedFamilies([.systemLarge, .systemExtraLarge])
    }
}
