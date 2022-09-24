import SwiftUI
import Charts

extension Stats {
    struct Display: View {
        @ObservedObject var session: Session
        @ObservedObject var options: Options
        private let symbol: some ChartSymbolShape = Circle().strokeBorder(lineWidth: 0)
        private let symbolSize = CGSize(width: 12, height: 12)
        private let pointSize = CGSize(width: 5, height: 5)
        
        var body: some View {
            Chart {
                series()
                
                RuleMark(y: .value(session.challenge.series.title, session.challenge.value))
                    .lineStyle(StrokeStyle(lineWidth: 1.5))
                    .foregroundStyle(session.challenge.series.color)
                    .annotation(position: .top, alignment: .leading) {
                        Text(session.challenge.title)
                            .font(.footnote.weight(.medium))
                            .foregroundColor(session.challenge.series.color)
                            .opacity(options.challenge ? 1 : 0.2)
                    }
                    .opacity(options.challenge ? 1 : 0.2)
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: 240)
            .chartPlotStyle { plot in
                plot.padding()
            }
            .chartOverlay {
                overlay(overlay: $0)
            }
            .chartBackground {
                background(background: $0)
            }
            .padding(.vertical, 40)
        }
        
        private func overlay(overlay: ChartProxy) -> some View {
            GeometryReader { proxy in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                let selected = session.find(location: value.location, overlay: overlay, proxy: proxy)
                                
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if selected == options.selected {
                                        options.selected = nil
                                    } else {
                                        options.selected = selected
                                    }
                                }
                            }
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        let selected = session.find(location: value.location, overlay: overlay, proxy: proxy)
                                        
                                        if selected != options.selected {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                options.selected = selected
                                            }
                                        }
                                    }
                            )
                    )
            }
        }
        
        @ViewBuilder private func background(background: ChartProxy) -> some View {
            Rectangle()
                .fill(Color(.systemBackground))
                .frame(height: 320)
                .frame(maxWidth: .greatestFiniteMagnitude)
            
            if let last = session.fortnight.last, let x = background.position(forX: last.date) {
                Capsule()
                    .fill(session.color.opacity(0.15))
                    .frame(width: 20, height: 260)
                    .position(x: x + 15, y: 160)
                    .opacity(options.selected == nil ? 1 : 0)
            }
            
            if let selected = options.selected, let x = background.position(forX: selected.date) {
                Rectangle()
                    .fill(Color.accentColor.opacity(0.35))
                    .frame(width: 20, height: 320)
                    .position(x: x + 15, y: 160)
            }
        }
        
        @ChartContentBuilder private func series() -> some ChartContent {
            ForEach(session.fortnight, id: \.self) { walk in
                series(.calories,
                       date: walk.date,
                       value: walk.calories)
                .opacity(options.calories ? 1 : 0.2)
                
                series(.distance,
                       date: walk.date,
                       value: walk.distance)
                .opacity(options.distance ? 1 : 0.2)
                
                series(.steps,
                       date: walk.date,
                       value: walk.steps)
                .opacity(options.steps ? 1 : 0.2)
            }
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
}
