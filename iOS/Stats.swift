import SwiftUI
import Charts

struct Stats: View {
    @ObservedObject var session: Session
    @State private var calories = true
    @State private var distance = true
    @State private var steps = true
    @State private var challenge = true
    @Environment(\.dismiss) private var dismiss
    private let symbol: some ChartSymbolShape = Circle().strokeBorder(lineWidth: 0)
    private let symbolSize = CGSize(width: 12, height: 12)
    private let pointSize = CGSize(width: 5, height: 5)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    heading
                    chart
                }
                .background(Color(.systemBackground), ignoresSafeAreaEdges: .all)
                
                Divider()
                
                filters
                rule
                time
            }
        }
        .background(session.color.opacity(0.2).gradient, ignoresSafeAreaEdges: .all)
    }
    
    @ViewBuilder private var heading: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text("Daily Achievements")
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
    }
    
    @ViewBuilder private var chart: some View {
        Divider()
            .padding(.bottom, 40)
        
        Chart {
            if (calories || distance || steps), let last = session.walks.last {
                RectangleMark(x: .value("", last.date, unit: .day),
                              yStart: -25,
                              yEnd: 265,
                              width: .ratio(0.8))
                .foregroundStyle(session.challenge.series.color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                
                ForEach(session.walks.suffix(7), id: \.self) { walk in
                    if calories {
                        series(.calories, date: walk.date, value: walk.calories)
                    }
                    
                    if distance {
                        series(.distance, date: walk.date, value: walk.distance)
                    }
                    
                    if steps {
                        series(.steps, date: walk.date, value: walk.steps)
                    }
                }
                
                if challenge {
                    RuleMark(y: .value("Steps", 6000))
                        .lineStyle(StrokeStyle(lineWidth: 1))
                        .foregroundStyle(.indigo.opacity(0.6))
                        .annotation(position: .top, alignment: .leading) {
                            Text("6000 Steps")
                                .font(.footnote.weight(.regular))
                                .foregroundColor(.indigo.opacity(0.6))
                        }
                }
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(height: 240)
        .padding(.horizontal)
        
        Divider()
            .padding(.top, 40)
    }
    
    private var filters: some View {
        section {
            toggle(.calories, value: $calories)
            Divider()
            toggle(.distance, value: $distance)
            Divider()
            toggle(.steps, value: $steps)
        }
        .padding(.top)
    }
    
    private var rule: some View {
        section {
            Toggle(isOn: $challenge.animation(.easeInOut)) {
                HStack(spacing: 12) {
                    Text("Challenge rule")
                        .font(.callout.weight(.regular))
                        .foregroundStyle(.secondary)
                    Capsule()
                        .fill(session.challenge.series.color)
                        .frame(width: 30, height: 3)
                    Spacer()
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: session.challenge.series.color))
        }
        .padding(.vertical)
    }
    
    private var time: some View {
        section {
            Button {
                
            } label: {
                Text("Achievements Over Time")
                    .font(.callout.weight(.medium))
                    .frame(maxWidth: .greatestFiniteMagnitude, minHeight: 30)
                    .contentShape(Rectangle())
            }
        }
        .padding(.bottom)
    }
    
    private func toggle(_ series: Series, value: Binding<Bool>) -> some View {
        Toggle(isOn: value.animation(.easeInOut)) {
            HStack(spacing: 0) {
                Circle()
                    .fill(series.color)
                    .frame(width: 14, height: 14)
                
                Image(systemName: series.symbol)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.tertiary)
                    .frame(width: 30)
                    .padding(.leading, 5)
                
                Text(series.title)
                    .font(.callout.weight(.regular))
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: series.color))
    }
    
    private func section(@ViewBuilder content: () -> some View) -> some View {
        VStack {
            content()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemBackground)))
        .padding(.horizontal)
    }
    
    @ChartContentBuilder private func series(_ series: Series, date: Date, value: some Plottable) -> some ChartContent {
        LineMark(x: .value("Day", date, unit: .day),
                 y: .value(series.title, value),
                 series: .value("Daily", series.title))
        .interpolationMethod(.monotone)
        .foregroundStyle(series.color)
        .symbol(symbol)
        .symbolSize(symbolSize)
        
        PointMark(x: .value("Day", date, unit: .day),
                  y: .value(series.title, value))
        .symbolSize(pointSize)
        .foregroundStyle(series.color)
    }
}
