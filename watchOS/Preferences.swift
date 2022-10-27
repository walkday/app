import SwiftUI

struct Preferences: View {
    @ObservedObject var session: Session
    
    var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                Text("Metrics")
                    .font(.title3.weight(.medium))
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding(.bottom)
                Metric(value: $session.settings.watch.calories, series: .calories)
                Divider()
                Metric(value: $session.settings.watch.distance, series: .distance)
                Divider()
                Metric(value: $session.settings.watch.steps, series: .steps)
                Spacer()
            }
            .padding([.leading, .trailing, .bottom])
        }
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .onChange(of: session.settings) { settings in
            Task {
                await session.cloud.update(settings: settings)
            }
        }
    }
}
