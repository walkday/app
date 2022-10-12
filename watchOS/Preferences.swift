import SwiftUI

struct Preferences: View {
    @ObservedObject var session: Session
    
    var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                Text("Metrics")
                    .font(.title2.weight(.medium))
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding(.bottom)
                Metric(value: $session.settings.tracker.calories, series: .calories)
                Divider()
                Metric(value: $session.settings.tracker.distance, series: .distance)
                Divider()
                Metric(value: $session.settings.tracker.steps, series: .steps)
                Spacer()
            }
            .padding([.leading, .trailing, .bottom])
        }
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background {
            LinearGradient(stops: [.init(color: session.color, location: 0),
                                   .init(color: session.color.opacity(0.6), location: 1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
        }
        .onChange(of: session.settings) { settings in
            Task {
                await session.cloud.update(watchOS: settings)
            }
        }
    }
}
