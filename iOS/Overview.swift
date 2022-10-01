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
                    .padding(.leading, 20)
                    .zIndex(1)
                
                Chart {
                    if let last = session.walks.last {
                        RectangleMark(x: .value("", last.date, unit: .day),
                                      yStart: -64,
                                      yEnd: 96,
                                      width: .ratio(1.1))
                        .foregroundStyle(session.color)
                        
                        ForEach(session.walks, id: \.self) { walk in
                            BarMark(x: .value("Day", walk.date, unit: .day),
                                    yStart: .value("", 0),
                                    yEnd: .value("", walk == last
                                                 ? session.settings.challenge.partial(walk: walk)
                                                 : session.settings.challenge.challenged(walk: walk)),
                                    width: .ratio(0.3))
                            .clipShape(Capsule())
                            .foregroundStyle(Color(.systemBackground)
                                .opacity(walk == last
                                         ? 1
                                         : session.settings.challenge.achieved(walk: walk)
                                            ? 1
                                            : 0.35))
                            .accessibilityValue(session.settings.challenge.percent(walk: walk).formatted(.percent))
                        }
                        
                        BarMark(x: .value("", last.date, unit: .day),
                                yStart: .value("", session.settings.challenge.activeMin(walk: last)),
                                yEnd: .value("", session.settings.challenge.activeMax(walk: last)),
                                width: .ratio(0.3))
                        .clipShape(Capsule())
                        .foregroundStyle(Color(.systemBackground).opacity(0.5))
                    }
                }
                .chartYAxis(.hidden)
                .chartXAxis(.hidden)
                .chartYScale(domain: 0 ... session.settings.challenge.value)
                .chartXScale(range: .plotDimension(padding: 20))
                .chartBackground { proxy in
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color("Overview"))
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(.white.opacity(0.4), style: .init(lineWidth: 1))
                    }
                    .frame(height: 162)
                    .offset(y: -22)
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
