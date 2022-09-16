import SwiftUI
import Charts

struct Overview: View {
    let color: Color
    @State private var stats = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(LinearGradient(colors: [.init(.systemBackground).opacity(0.8),
                                              .init(.systemBackground).opacity(0.4)],
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing)
                    .shadow(.inner(color: .white, radius: 1)))
            
            Button {
                stats = true
            } label: {
                VStack {
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
                .padding()
            }
            .padding(20)
            .sheet(isPresented: $stats, content: Stats.init)
        }
        .shadow(color: color.opacity(0.15), radius: 4)
        .padding(.horizontal)
    }
}
