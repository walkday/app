import SwiftUI
import Charts

struct Walk: Hashable {
    let date: Date
    let steps: Int
    let calories: Int
    let distance: Int
}

let walks: [Walk] = (1 ... 30)
    .map {
        .init(date: Calendar.current.date(byAdding: .day, value: -($0), to: .now)!,
              steps: .random(in: 3000 ..< 7000),
              calories: .random(in: 500 ..< 3000),
              distance: .random(in: 2000 ..< 5000))
    }

struct Stats: View {
    @State private var range = 7
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack(alignment: .bottom, spacing: 0) {
                    Text("Daily Challenges")
                        .font(.title2.weight(.semibold))
                        .padding(.leading)
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24, weight: .regular))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                            .frame(width: 56, height: 56)
                            .contentShape(Rectangle())
                    }
                }
                
                Picker("Range", selection: $range.animation(.easeInOut)) {
                    Text("7 Days")
                        .tag(7)
                    Text("15 Days")
                        .tag(15)
                    Text("30 Days")
                        .tag(30)
                }
                .pickerStyle(.segmented)
                .padding()
                
                Divider()
                    .padding(.bottom, 30)
                
                Chart {
                    ForEach(walks.prefix(range), id: \.self) { walk in
                        LineMark(x: .value("Day", walk.date, unit: .day),
                                 y: .value("Steps", walk.steps))
                        .interpolationMethod(.monotone)
                        .foregroundStyle(by: .value("Daily", "Steps"))
                        .symbol {
    //                            Image(systemName: "figure.run")
                            Circle()
                                .stroke(.blue, style: .init(lineWidth: 2))
                                .frame(width: 8, height: 8)
                        }
                        .symbol(.circle)
                        .symbolSize(10)
                        
                        LineMark(x: .value("Day", walk.date, unit: .day),
                                 y: .value("Distance", walk.distance))
                        .interpolationMethod(.monotone)
                        .foregroundStyle(by: .value("Daily", "Distance"))
                        .symbol(by: .value("Daily", "Distance"))
                        
                        LineMark(x: .value("Day", walk.date, unit: .day),
                                 y: .value("Calories", walk.calories))
                        .interpolationMethod(.monotone)
                        .foregroundStyle(by: .value("Daily", "Calories"))
                        .symbol(by: .value("Daily", "Calories"))
                    }
                }
                .chartYAxis(.hidden)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { _ in
                        AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
                    }
                }
                .frame(height: 260)
                
                Divider()
                    .padding(.top, 30)
            }
        }
    }
}
