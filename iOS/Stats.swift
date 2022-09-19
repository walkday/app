import SwiftUI
import Charts

struct Walk: Hashable {
    let date: Date
    let steps: Int
    let calories: Int
    let distance: Int
}

let walks: [Walk] = (1 ... 15)
    .map {
        .init(date: Calendar.current.date(byAdding: .day, value: -($0), to: .now)!,
              steps: .random(in: 3000 ..< 7000),
              calories: .random(in: 500 ..< 3000),
              distance: .random(in: 2000 ..< 5000))
    }

struct Stats: View {
    var body: some View {
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
        .presentationDetents([.fraction(0.5)])
    }
}
