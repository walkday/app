import SwiftUI
import WidgetKit

struct Large: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Large", provider: Provider()) { entry in
            Text(entry.error == nil ? "No error" : entry.error!.localizedDescription)
                .lineLimit(0)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
        }
        .configurationDisplayName("Large")
        .description("Progress and metrics")
        .supportedFamilies([.systemLarge, .systemExtraLarge])
    }
}
