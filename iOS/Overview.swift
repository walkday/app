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
                                    yEnd: .value("", session.challenge.progress(walk: walk)),
                                    width: .ratio(0.3))
                            .clipShape(Capsule())
                            .foregroundStyle(session.challenge.achieved(walk: walk) || walk == last
                                             ? Color(.systemBackground)
                                             : session.color.opacity(0.25))
                            .accessibilityValue(session.challenge.percent(walk: walk).formatted(.percent))
                        }
                    }
                }
                .chartYAxis(.hidden)
                .chartXAxis(.hidden)
                .chartYScale(domain: 0 ... session.challenge.value)
                .chartXScale(range: .plotDimension(padding: 20))
                .chartBackground { proxy in
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color("Overview"))
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
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
