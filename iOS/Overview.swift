import SwiftUI
import Charts

struct Overview: View {
    @ObservedObject var session: Session
    @State private var stats = false
    
    var body: some View {
        Button {
            stats = true
        } label: {
            VStack(alignment: .leading, spacing: 20) {
                Text("14 days")
                    .foregroundColor(.white)
                    .font(.callout.weight(.semibold))
                    .padding(.leading, 20)
                
                Chart {
                    if let last = session.walks.last {
                        ForEach(session.walks, id: \.self) { walk in
                            BarMark(x: .value("Day", walk.date, unit: .day),
                                    yStart: .value("", 0),
                                    yEnd: .value("", session.challenge.progress(walk: walk)),
                                    width: .ratio(0.3))
                            .clipShape(Capsule())
                            .foregroundStyle(LinearGradient(
                                colors: walk == last
                                ? [.white]
                                : session.challenge.achieved(walk: walk)
                                    ? [session.color]
                                    : [.clear, session.color.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing))
                            .accessibilityValue(session.challenge.percent(walk: walk).formatted(.percent))
                        }
                    }
                }
                .chartYAxis(.hidden)
                .chartXAxis(.hidden)
                .chartYScale(domain: 0 ... session.challenge.value)
                .chartXScale(range: .plotDimension(padding: 20))
            }
        }
        .frame(height: 90)
        .padding(.horizontal)
        .sheet(isPresented: $stats) {
            Stats(session: session)
        }
    }
}
