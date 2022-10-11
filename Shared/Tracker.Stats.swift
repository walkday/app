import SwiftUI
import Walker

extension Tracker {
    struct Stats: View {
        let walk: Walk
        let metrics: Settings.Metrics
        
        var body: some View {
            Grid(verticalSpacing: 4) {
                GridRow(alignment: .firstTextBaseline) {
                    if metrics.calories {
                        Text("\(Image(systemName: Series.calories.symbol)) \(Text(Series.calories.title).font(.system(size: 14, weight: .regular)))")
                        
                        if metrics.distance || metrics.steps {
                            Spacer()
                        }
                    }
                    
                    if metrics.distance {
                        Text("\(Image(systemName: Series.distance.symbol)) \(Text(Series.distance.title).font(.system(size: 14, weight: .regular)))")
                        
                        if metrics.steps {
                            Spacer()
                        }
                    }
                    
                    if metrics.steps {
                        Text("\(Image(systemName: Series.steps.symbol)) \(Text(Series.steps.title).font(.system(size: 14, weight: .regular)))")
                    }
                }
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(.secondary)
                
                GridRow(alignment: .firstTextBaseline) {
                    if metrics.calories {
                        Text(Series.calories.string(from: walk.calories)
                            .numeric(font: .title2.weight(.semibold).monospacedDigit(),
                                     color: .init(.systemBackground)))
                        
                        if metrics.distance || metrics.steps {
                            Spacer()
                        }
                    }
                    
                    if metrics.distance {
                        Text(Series.distance.string(from: walk.distance)
                            .numeric(font: .title2.weight(.semibold).monospacedDigit(),
                                     color: .init(.systemBackground)))
                        
                        if metrics.steps {
                            Spacer()
                        }
                    }
                    
                    if metrics.steps {
                        Text(AttributedString.plain(value: walk.steps)
                            .numeric(font: .title2.weight(.semibold).monospacedDigit(),
                                     color: .init(.systemBackground)))
                    }
                }
                .font(.callout.weight(.regular))
                .foregroundColor(.init(.systemBackground).opacity(0.5))
            }
//            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
