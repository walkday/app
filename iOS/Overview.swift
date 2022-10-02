import SwiftUI
import Charts

struct Overview: View {
    @ObservedObject var session: Session
    @State private var stats = false
    
    var body: some View {
        Button {
            stats = true
        } label: {
            VStack(alignment: .leading, spacing: 15) {
                Text("14 days")
                    .foregroundColor(.init(.systemBackground))
                    .font(.callout.weight(.semibold))
                    .padding(.leading, 20)
                    .zIndex(1)
                
                Chart {
                    if let last = session.walks.last {
                        RectangleMark(x: .value("", last.date, unit: .day),
                                      yStart: -51,
                                      yEnd: 70,
                                      width: .ratio(1.1))
                        .foregroundStyle(Color(.systemBackground).opacity(0.3))
                        
                        ForEach(session.walks, id: \.self) { walk in
                            BarMark(x: .value("Day", walk.date, unit: .day),
                                    yStart: .value("", 0),
                                    yEnd: .value("", walk == last
                                                 ? session.settings.challenge.partial(walk: walk)
                                                 : session.settings.challenge.challenged(walk: walk)),
                                    width: .ratio(0.3))
                            .clipShape(Capsule())
                            .foregroundStyle(session.settings.challenge.achieved(walk: walk)
                                             ? Color(.systemBackground)
                                             : session.color)
                            .accessibilityValue(session.settings.challenge.percent(walk: walk).formatted(.percent))
                        }
                        
                        if !session.settings.challenge.achieved(walk: last) {
                            BarMark(x: .value("", last.date, unit: .day),
                                    yStart: .value("", session.settings.challenge.activeMin(walk: last)),
                                    yEnd: .value("", session.settings.challenge.activeMax(walk: last)),
                                    width: .ratio(0.3))
                            .clipShape(Capsule())
                            .foregroundStyle(session.color)
                        }
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
                            .stroke(.white.opacity(0.3), style: .init(lineWidth: 1))
                    }
                    .frame(height: 122)
                    .offset(y: -14)
                }
            }
        }
        .frame(height: 80)
        .padding(.horizontal)
        .sheet(isPresented: $stats) {
            Stats(session: session)
        }
    }
}
