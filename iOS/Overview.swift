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
                Text("7 days")
                    .foregroundColor(.init(.systemBackground))
                    .font(.callout.weight(.semibold))
                    .zIndex(1)
                Chart {
                    if let last = session.walks.last {
                        ForEach(session.walks.suffix(7), id: \.self) { walk in
                            BarMark(x: .value("Day", walk.date, unit: .day),
                                    yStart: .value("", 0),
                                    yEnd: .value("", walk.steps),
                                    width: .ratio(0.25))
                            .clipShape(Capsule())
                            .foregroundStyle(walk == last ? .white.opacity(0.4) : Color(.systemBackground))
                            .accessibilityValue("\(walk.steps / 7000)%")
                        }
                        
                        RectangleMark(x: .value("", last.date, unit: .day),
                                      yStart: -65,
                                      yEnd: 96,
                                      width: .ratio(1.1))
                            .foregroundStyle(.white.opacity(0.4))
                        
                        BarMark(x: .value("", last.date, unit: .day),
                                yStart: .value("", max(0, last.steps - (7000 / 10))),
                                yEnd: .value("", min(7000, last.steps + (7000 / 10))),
                                width: .ratio(0.25))
                        .clipShape(Capsule())
                        .foregroundStyle(Color(.systemBackground))
                    }
                }
                .chartYAxis(.hidden)
                .chartXAxis(.hidden)
                .chartYScale(domain: 0 ... 7000)
                .chartPlotStyle { plot in
                    plot.background(RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.white.opacity(0.3))
                        .padding(.init(top: -65, leading: -20, bottom: -20, trailing: -20)))
                }
            }
        }
        .frame(width: 240, height: 120)
        .padding(.horizontal, 40)
        .sheet(isPresented: $stats) {
            Stats(session: session)
        }
    }
}
