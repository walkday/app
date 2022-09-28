import SwiftUI
import Charts
import Walker

extension Stats {
    struct Display: View {
        @ObservedObject var session: Session
        @Binding var selected: Walk?
        private let symbol: some ChartSymbolShape = Circle().strokeBorder(lineWidth: 0)
        private let symbolSize = CGSize(width: 12, height: 12)
        private let pointSize = CGSize(width: 5, height: 5)
        
        var body: some View {
            Chart {
                series()
                
                RuleMark(y: .value(session.preferences.challenge.series.title, session.preferences.challenge.value))
                    .lineStyle(StrokeStyle(lineWidth: 1.5))
                    .foregroundStyle(session.preferences.challenge.series.color)
                    .annotation(position: .top, alignment: .leading) {
                        Text(session.preferences.challenge.title)
                            .font(.footnote.weight(.medium))
                            .foregroundColor(session.preferences.challenge.series.color)
                            .opacity(session.preferences.goal ? 1 : 0.2)
                    }
                    .opacity(session.preferences.goal ? 1 : 0.2)
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
                                    if selected == self.selected {
                                        self.selected = nil
                                    } else {
                                        self.selected = selected
                                    }
                                }
                            }
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        let selected = session.find(location: value.location, overlay: overlay, proxy: proxy)
                                        
                                        if selected != self.selected {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                self.selected = selected
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
            
            if let last = session.walks.last, let x = background.position(forX: last.date) {
                Capsule()
                    .fill(session.color.opacity(0.15))
                    .frame(width: 20, height: 260)
                    .position(x: x + 15, y: 160)
                    .opacity(selected == nil ? 1 : 0)
            }
            
            if let selected = selected, let x = background.position(forX: selected.date) {
                Rectangle()
                    .fill(Color.accentColor.opacity(0.35))
                    .frame(width: 1200, height: 1)
                    .position(x: x + 17.5, y: 0)
                
                Rectangle()
                    .fill(Color.accentColor.opacity(0.35))
                    .frame(width: 20, height: 319)
                    .position(x: x + 17.5, y: 160)
            }
        }
        
        @ChartContentBuilder private func series() -> some ChartContent {
            ForEach(session.walks, id: \.self) { walk in
                series(.calories,
                       date: walk.date,
                       value: walk.calories)
                .opacity(session.preferences.calories ? 1 : 0.2)
                
                series(.distance,
                       date: walk.date,
                       value: walk.distance)
                .opacity(session.preferences.distance ? 1 : 0.2)
                
                series(.steps,
                       date: walk.date,
                       value: walk.steps)
                .opacity(session.preferences.steps ? 1 : 0.2)
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
