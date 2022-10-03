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
                
                if session.goal {
                    RuleMark(y: .value(session.settings.challenge.series.title, session.settings.challenge.value))
                        .lineStyle(StrokeStyle(lineWidth: 4))
                        .foregroundStyle(session.settings.challenge.series.color.opacity(0.3))
                        .annotation(position: .top, alignment: .leading) {
                            Text(session.settings.challenge.title)
                                .font(.footnote.weight(.medium))
                                .foregroundColor(session.settings.challenge.series.color)
                                .padding(.leading, 20)
                        }
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .chartXScale(range: .plotDimension(padding: 20))
            .frame(height: 240)
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
                    .position(x: x + 10, y: 160)
                    .opacity(selected == nil ? 1 : 0)
            }
            
            if let selected = selected, let x = background.position(forX: selected.date) {
                Rectangle()
                    .fill(Color.accentColor.opacity(0.35))
                    .frame(width: 1200, height: 1)
                    .position(x: x, y: 0)
                
                Rectangle()
                    .fill(Color.accentColor.opacity(0.35))
                    .frame(width: 20, height: 319)
                    .position(x: x + 12.5, y: 160)
            }
        }
        
        @ChartContentBuilder private func series() -> some ChartContent {
            ForEach(session.walks, id: \.self) { walk in
                series(.calories,
                       date: walk.date,
                       value: walk.calories,
                       active: session.settings.calories)
                
                series(.distance,
                       date: walk.date,
                       value: walk.distance,
                       active: session.settings.distance)
                
                series(.steps,
                       date: walk.date,
                       value: walk.steps,
                       active: session.settings.steps)
            }
        }
        
        @ChartContentBuilder private func series(_ series: Series,
                                                 date: Date,
                                                 value: some Plottable,
                                                 active: Bool) -> some ChartContent {
            if active {
                LineMark(x: .value("Day", date, unit: .day),
                         y: .value(series.title, value),
                         series: .value("Daily", series.title))
                .interpolationMethod(.catmullRom)
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
}
