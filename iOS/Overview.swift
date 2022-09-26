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
                                    yEnd: .value("", walk == last ? walk.steps - (7000 / 6) : walk.steps),
                                    width: .ratio(0.3))
                            .clipShape(Capsule())
                            .foregroundStyle(Color(.systemBackground))
                            .accessibilityValue("\(walk.steps / 7000)%")
                        }
                        
                        BarMark(x: .value("", last.date, unit: .day),
                                yStart: .value("", max(0, last.steps - (7000 / 10))),
                                yEnd: .value("", min(7000, last.steps + (7000 / 10))),
                                width: .ratio(0.3))
                        .clipShape(Capsule())
                        .foregroundStyle(Color(.systemBackground).opacity(0.75))
                    }
                }
                .chartYAxis(.hidden)
                .chartXAxis(.hidden)
                .chartYScale(domain: 0 ... 7000)
                .chartBackground { proxy in
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.white.opacity(0.3))
                            .frame(height: 162)
                            .offset(y: -22)
                    }
                }
                .chartPlotStyle { plot in
                    plot
                        .scenePadding(.horizontal)
                        .scenePadding(.horizontal)
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
