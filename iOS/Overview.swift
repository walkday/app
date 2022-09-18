import SwiftUI
import Charts

struct Overview: View {
    let color: Color
    @State private var stats = false
    
    var body: some View {
        Button {
            stats = true
        } label: {
            Chart {
                
                
                ForEach(walks, id: \.self) { walk in
                    BarMark(x: .value("Day", walk.date, unit: .weekdayOrdinal),
                            y: .value("Calories", walk.calories))
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(by: .value("Daily", "Calories"))
                    .symbol(by: .value("Daily", "Calories"))
                }
                
                RuleMark(
                    y: .value("Average", walks.first!.calories)
                )
                .lineStyle(StrokeStyle(lineWidth: 1))
                .annotation(position: .top, alignment: .leading) {
                    Text("Goal")
                        .font(.body.bold())
                        .foregroundStyle(.blue)
                }
            }
            .chartYAxis(.hidden)
        }
        .padding([.bottom, .leading, .trailing], 30)
        .padding(.top, 50)
        .sheet(isPresented: $stats, content: Stats.init)
    }
}
