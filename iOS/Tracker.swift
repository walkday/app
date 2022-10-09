import SwiftUI
import Walker

struct Tracker: View {
    let walk: Walk
    let percent: Double
    let color: Color
    let metrics: Settings.Metrics
    
    var body: some View {
        ZStack {
            background
            VStack(spacing: 0) {
                progress
                    .padding(.top, 10)
                
                Text(caption)
                    .font(.callout.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 25)
                
                if metrics.content {
                    grid
                }
            }
            .padding(.vertical, 10)
        }
        .foregroundColor(.init(.systemBackground))
        .shadow(color: color.opacity(0.4), radius: 4)
        .padding(.horizontal)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    @ViewBuilder private var background: some View {
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .fill(.white)
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .fill(LinearGradient(colors: [color,
                                          color.opacity(0.6)],
                                 startPoint: .topLeading,
                                 endPoint: .bottomTrailing)
                .shadow(.inner(color: .white, radius: 1)))
    }
    
    private var progress: some View {
        ZStack {
            ZStack {
                Progress(value: 1)
                    .stroke(.tertiary, style: .init(lineWidth: 5, lineCap: .round))
                Progress(value: percent)
                    .stroke(Color(.systemBackground), style: .init(lineWidth: 5, lineCap: .round))
                    .animation(.easeInOut(duration: 0.6), value: percent)
            }
            .frame(height: 160)
            
            VStack(spacing: 7) {
                Spacer()
                Text(min(Int(percent * 100), 100).formatted())
                    .font(.system(size: percent >= 1 ? 52 : 60, weight: .semibold).monospacedDigit())
                Text(verbatim: "%")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(.init(.systemBackground))
                    .padding(.bottom, 7)
            }
        }
    }
    
    private var grid: some View {
        Grid(horizontalSpacing: 18, verticalSpacing: 4) {
            GridRow(alignment: .firstTextBaseline) {
                if metrics.calories {
                    Text("\(Image(systemName: Series.calories.symbol)) \(Text(Series.calories.title).font(.system(size: 14, weight: .regular)))")
                }
                
                if metrics.distance {
                    Text("\(Image(systemName: Series.distance.symbol)) \(Text(Series.distance.title).font(.system(size: 14, weight: .regular)))")
                }
                
                if metrics.steps {
                    Text("\(Image(systemName: Series.steps.symbol)) \(Text(Series.steps.title).font(.system(size: 14, weight: .regular)))")
                }
            }
            .font(.system(size: 11, weight: .regular))
            .foregroundStyle(.secondary)
            
            GridRow(alignment: .firstTextBaseline) {
                if metrics.calories {
                    Text(Series.calories.string(from: walk.calories, caption: false)
                        .numeric(font: .title2.weight(.semibold).monospacedDigit(),
                                 color: .init(.systemBackground)))
                }
                
                if metrics.distance {
                    Text(Series.distance.string(from: walk.distance, caption: true)
                        .numeric(font: .title2.weight(.semibold).monospacedDigit(),
                                 color: .init(.systemBackground)))
                }
                
                if metrics.steps {
                    Text(Series.steps.string(from: walk.steps, caption: false)
                        .numeric(font: .title2.weight(.semibold).monospacedDigit(),
                                 color: .init(.systemBackground)))
                }
            }
            .font(.callout.weight(.regular))
            .foregroundColor(.init(.systemBackground).opacity(0.5))
        }
        .multilineTextAlignment(.center)
        .padding(.bottom, 20)
    }
    
    private var caption: String {
        switch percent {
        case 1...:
            return "Challenge completed!"
        case 0.7 ..< 1:
            return "You are doing great!"
        case 0 ... 0.3:
            return "You have this, keep walking"
        default:
            return "Half way there"
        }
    }
}
