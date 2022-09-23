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
            Divider()
                .padding(.bottom, 40)
            
            Chart {
                if options.display, let last = session.walks.last {
                    if let selected = options.selected {
                        RectangleMark(x: .value("", selected.date, unit: .day),
                                      yStart: -40,
                                      yEnd: 280,
                                      width: .ratio(0.4))
                        .foregroundStyle(Color.primary.opacity(0.2))
                    } else {
                        RectangleMark(x: .value("", last.date, unit: .day),
                                      yStart: -25,
                                      yEnd: 265,
                                      width: .ratio(0.8))
                        .foregroundStyle(session.challenge.series.color.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    
                    ForEach(session.fortnight, id: \.self) { walk in
                        if options.calories {
                            series(.calories, date: walk.date, value: walk.calories)
                        }
                        
                        if options.distance {
                            series(.distance, date: walk.date, value: walk.distance)
                        }
                        
                        if options.steps {
                            series(.steps, date: walk.date, value: walk.steps)
                        }
                    }
                    
                    if options.challenge {
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
            .chartOverlay { overlay in
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
            .frame(height: 240)
            .padding(.horizontal)
            
            Divider()
                .padding(.top, 40)
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
