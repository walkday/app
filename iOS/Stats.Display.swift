import SwiftUI
import Charts
import Walker

extension Stats {
    struct Display: View {
        @ObservedObject var session: Session
        @Binding var selected: Walk?
        
        var body: some View {
            Chart {
                if session.settings.goal && session.settings.stats[keyPath: session.challenge.series.metric] {
                    RuleMark(y: .value(session.challenge.series.title, session.challenge.value))
                        .lineStyle(StrokeStyle(lineWidth: selected == nil ? 22 : 2))
                        .foregroundStyle(Color.primary.opacity(selected == nil ? 0.2 : 0.5))
                        .annotation(position: .overlay, alignment: .leading) {
                            if selected == nil {
                                Text(session.challenge.series.challenge(value: .init(session.challenge.value)))
                                    .font(.footnote.weight(.medium))
                                    .foregroundColor(.init(.systemBackground))
                                    .padding(.leading, 20)
                            }
                        }
                }
                
                series()
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
            .padding(.top, 60)
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
                .frame(height: 360)
                .frame(maxWidth: .greatestFiniteMagnitude)
            
            if let selected {
                Rectangle()
                    .fill(Color.accentColor.opacity(0.75))
                    .frame(width: 1200, height: 2)
                    .position(x: 600, y: 0)
                
                if let x = background.position(forX: selected.date) {
                    Rectangle()
                        .fill(Color.accentColor.opacity(0.75))
                        .frame(width: 20, height: 359)
                        .position(x: x + 12.5, y: 180.5)
                }
            } else {
                Rectangle()
                    .fill(session.color.opacity(0.15))
                    .frame(width: 1200, height: 2)
                    .position(x: 600, y: 0)
                
                if let last = session.walks.last, let x = background.position(forX: last.date) {
                    Rectangle()
                        .fill(session.color.opacity(0.15))
                        .frame(width: 20, height: 359)
                        .position(x: x + 12.5, y: 180.5)
                }
            }
        }
        
        @ChartContentBuilder private func series() -> some ChartContent {
            ForEach(session.walks, id: \.self) { walk in
                series(.calories,
                       date: walk.date,
                       value: walk.calories,
                       active: session.settings.stats.calories)
                
                series(.distance,
                       date: walk.date,
                       value: walk.distance,
                       active: session.settings.stats.distance)
                
                series(.steps,
                       date: walk.date,
                       value: walk.steps,
                       active: session.settings.stats.steps)
            }
        }
        
        @ChartContentBuilder private func series(_ series: Series,
                                                 date: Date,
                                                 value: Int,
                                                 active: Bool) -> some ChartContent {
            if active {
                LineMark(x: .value("Day", date, unit: .day),
                         y: .value(series.title, value),
                         series: .value("Daily", series.title))
                .lineStyle(.init(lineWidth: 6))
                .interpolationMethod(.catmullRom(alpha: 1))
                .foregroundStyle(series.color.opacity(selected == nil ? 0.6 : 0.2))
                .symbol(Circle().strokeBorder(lineWidth: 0))
                .symbolSize(.init(width: 14, height: 14))
                
                if session.challenge.series == series && value >= .init(session.challenge.value) {
                    PointMark(x: .value("Day", date, unit: .day),
                              y: .value(series.title, value))
                    .symbolSize(.init(width: 12, height: 12))
                    .foregroundStyle(series.color)
                } else {
                    PointMark(x: .value("Day", date, unit: .day),
                              y: .value(series.title, value))
                    .symbolSize(.init(width: 8, height: 8))
                    .foregroundStyle(series.color.opacity(selected == nil ? 0.35 : 0.5))
                }
            }
        }
    }
}
