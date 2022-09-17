import SwiftUI
import Charts

struct Overview: View {
    let color: Color
    @State private var stats = false
    
    var body: some View {
        Button {
            stats = true
        } label: {
            Chart(walks, id: \.self) { walk in
                LineMark(x: .value("Day", walk.date, unit: .day),
                         y: .value("Steps", walk.steps),
                         series: .value("Steps", "Steps"))
                .foregroundStyle(by: .value("Daily", "Steps"))
                .symbol(by: .value("Daily", "Steps"))
                
                LineMark(x: .value("Day", walk.date, unit: .day),
                         y: .value("Distance", walk.distance),
                         series: .value("Distance", "Distance"))
                .foregroundStyle(by: .value("Daily", "Distance"))
                .symbol(by: .value("Daily", "Distance"))
                
                LineMark(x: .value("Day", walk.date, unit: .day),
                         y: .value("Calories", walk.calories),
                         series: .value("Calories", "Calories"))
                .foregroundStyle(by: .value("Daily", "Calories"))
                .symbol(by: .value("Daily", "Calories"))
            }
        }
        .padding([.bottom, .leading, .trailing], 30)
        .padding(.top, 50)
        .sheet(isPresented: $stats, content: Stats.init)
    }
}
