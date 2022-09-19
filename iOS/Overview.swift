import SwiftUI
import Charts

struct Overview: View {
    let color: Color
    @State private var stats = false
    
    var body: some View {
        Button {
            stats = true
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.white.opacity(0.2))
                VStack(alignment: .leading, spacing: 20) {
                    Text("Past 2 weeks")
                        .font(.callout.weight(.medium))
                    Chart(walks, id: \.self) { walk in
                        BarMark(x: .value("Day", walk.date, unit: .day),
                                yStart: .value("", 0),
                                yEnd: .value("", walk.steps),
                                width: .ratio(0.4))
                        .cornerRadius(5, style: .circular)
                        .accessibilityValue("\(walk.steps / 7000)%")
                    }
                    .chartYAxis(.hidden)
                    .chartXAxis(.hidden)
                    .chartYScale(domain: 0 ... 7000)
                }
                .foregroundStyle(Color(.systemBackground))
                .padding(20)
            }
        }
        .frame(maxHeight: 140)
        .padding(.horizontal, 30)
        .sheet(isPresented: $stats, content: Stats.init)
    }
}
