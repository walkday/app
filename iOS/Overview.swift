import SwiftUI
import Charts

struct Overview: View {
    @ObservedObject var session: Session
    @State private var stats = false
    
    var body: some View {
        Button {
            stats = true
        } label: {
            VStack(alignment: .leading, spacing: 25) {
                Text("14 days")
                    .foregroundColor(.init(.systemBackground))
                    .font(.body.weight(.semibold))
                    .padding(.leading)
                    .padding(.leading)
                    .zIndex(1)
                Chart {
                    if let last = session.walks.last {
                        RectangleMark(x: .value("", last.date, unit: .day),
                                      yStart: -66,
                                      yEnd: 96,
                                      width: .ratio(1.1))
                        .foregroundStyle(session.color.opacity(0.4))
                        
                        ForEach(session.walks, id: \.self) { walk in
                            BarMark(x: .value("Day", walk.date, unit: .day),
                                    yStart: .value("", 0),
                                    yEnd: .value("", walk == last
                                                 ? session.settings.challenge.partial(walk: walk)
                                                 : session.settings.challenge.challenged(walk: walk)),
                                    width: .ratio(0.3))
                            .clipShape(Capsule())
                            .foregroundStyle(Color(.systemBackground))
                            .accessibilityValue(session.settings.challenge.percent(walk: walk))
                        }
                        
                        BarMark(x: .value("", last.date, unit: .day),
                                yStart: .value("", session.settings.challenge.activeMin(walk: last)),
                                yEnd: .value("", session.settings.challenge.activeMax(walk: last)),
                                width: .ratio(0.3))
                        .clipShape(Capsule())
                        .foregroundStyle(Color(.systemBackground).opacity(0.75))
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: session.walks)
                .chartYAxis(.hidden)
                .chartXAxis(.hidden)
                .chartYScale(domain: 0 ... session.settings.challenge.value)
                .chartXScale(range: .plotDimension(padding: 20))
                .chartBackground { proxy in
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.white.opacity(0.3))
                            .frame(height: 162)
                            .offset(y: -22)
                    }
                }
            }
        }
        .frame(height: 120)
        .padding(.horizontal)
        .sheet(isPresented: $stats) {
            Stats(session: session)
        }
    }
}
