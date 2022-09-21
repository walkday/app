import SwiftUI
import Charts

struct Walk: Hashable {
    let date: Date
    let steps: Int
    let calories: Int
    let distance: Int
}

let walks: [Walk] = (1 ... 300)
    .map {
        .init(date: Calendar.current.date(byAdding: .day, value: -($0), to: .now)!,
              steps: .random(in: 3000 ..< 7000),
              calories: .random(in: 500 ..< 3000),
              distance: .random(in: 2000 ..< 5000))
    }
    .reversed()

struct Stats: View {
    @State private var range = 7
    @Environment(\.dismiss) private var dismiss
    private let symbol: some ChartSymbolShape = Circle().strokeBorder(lineWidth: 0)
    private let symbolSize = CGSize(width: 12, height: 12)
    private let pointSize = CGSize(width: 5, height: 5)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack(alignment: .bottom, spacing: 0) {
                    Text("Daily Challenges")
                        .font(.title2.weight(.semibold))
                        .padding(.leading)
                        .offset(y: -2)
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
                
                Text("Past 7 days")
                    .font(.callout.weight(.regular))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding(.leading)
                    .padding(.bottom, 8)
                
                Divider()
                    .padding(.bottom, 30)
                
                Chart {
                    if let last = walks.last {
                        RectangleMark(x: .value("", last.date, unit: .day),
                                      yStart: -20,
                                      yEnd: 260,
                                      width: .ratio(0.8))
                        .foregroundStyle(.indigo.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    
                    ForEach(walks.suffix(7), id: \.self) { walk in
                        series("Steps", date: walk.date, value: walk.steps, color: .indigo)
                        series("Distance", date: walk.date, value: walk.distance, color: .teal)
                        series("Calories", date: walk.date, value: walk.calories, color: .orange)
                    }
                    
                    RuleMark(y: .value("Steps", 6000))
                        .lineStyle(StrokeStyle(lineWidth: 1))
                        .foregroundStyle(.indigo.opacity(0.6))
                        .annotation(position: .top, alignment: .leading) {
                            Text("6000 Steps")
                                .font(.footnote.weight(.regular))
                                .foregroundColor(.indigo.opacity(0.6))
                        }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .frame(height: 240)
                .padding(.horizontal)
                
                Divider()
                    .padding(.top, 30)
            }
        }
    }
    
    @ChartContentBuilder private func series(_ title: String, date: Date, value: some Plottable, color: Color) -> some ChartContent {
        LineMark(x: .value("Day", date, unit: .day),
                 y: .value(title, value),
                 series: .value("Daily", title))
        .interpolationMethod(.monotone)
        .foregroundStyle(color)
        .symbol(symbol)
        .symbolSize(symbolSize)
        
        PointMark(x: .value("Day", date, unit: .day),
                  y: .value(title, value))
        .symbolSize(pointSize)
        .foregroundStyle(color)
    }
}
