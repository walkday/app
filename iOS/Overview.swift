import SwiftUI
import Charts

struct Overview: View {
    let color: Color
    @State private var stats = false
    
    var body: some View {
        Button {
            stats = true
        } label: {
            VStack(alignment: .leading, spacing: 25) {
                Text("Past 2 weeks")
                    .foregroundColor(.init(.systemBackground))
                    .font(.callout.weight(.medium))
                    .zIndex(1)
                Chart {
                    if let first = walks.first {
//                        RuleMark(x: .value("Day", first.date, unit: .day),
//                                 yStart: .value("", 0),
//                                 yEnd: .value("", 7000))
                        
                        RectangleMark(x: .value("Day", first.date, unit: .day),
                                      yStart: -65,
                                      yEnd: 96,
                                      width: .ratio(1.2))
                            .foregroundStyle(.white.opacity(0.3))
                    }
                    
                    ForEach(walks, id: \.self) { walk in
                        BarMark(x: .value("Day", walk.date, unit: .day),
                                yStart: .value("", 0),
                                yEnd: .value("", walk.steps),
                                width: .ratio(0.35))
                        .cornerRadius(5, style: .circular)
                        .foregroundStyle(Color(.systemBackground))
                        .accessibilityValue("\(walk.steps / 7000)%")
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
        .frame(height: 120)
        .padding(.horizontal, 40)
        .sheet(isPresented: $stats, content: Stats.init)
    }
}
