import SwiftUI
import Walker

struct Tracker: View {
    @ObservedObject var session: Session
    
    var body: some View {
        ZStack {
            background
            VStack(spacing: 0) {
                progress
                    .padding(.top, 10)
                
                Text("You are doing great!")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 25)
                
                grid
            }
            .padding(.vertical, 10)
        }
        .foregroundColor(.init(.systemBackground))
        .shadow(color: session.color.opacity(0.4), radius: 4)
        .padding(.horizontal)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    @ViewBuilder private var background: some View {
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .fill(.white)
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .fill(LinearGradient(colors: [session.color,
                                          session.color.opacity(0.6)],
                                 startPoint: .topLeading,
                                 endPoint: .bottomTrailing)
                .shadow(.inner(color: .white, radius: 1)))
    }
    
    private var progress: some View {
        ZStack {
            ZStack {
                Progress(value: 1)
                    .stroke(.tertiary, style: .init(lineWidth: 5, lineCap: .round))
                Progress(value: 0.78)
                    .stroke(Color(.systemBackground), style: .init(lineWidth: 5, lineCap: .round))
            }
            .frame(height: 160)
            
            VStack(spacing: 7) {
                Spacer()
                Text("78")
                    .font(.system(size: 60, weight: .semibold).monospacedDigit())
                Text(verbatim: "%")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(.init(.systemBackground))
                    .padding(.bottom, 7)
            }
        }
    }
    
    private var grid: some View {
        Grid(horizontalSpacing: 25, verticalSpacing: 4) {
            GridRow {
                Text("\(Image(systemName: Series.calories.symbol)) \(Text(Series.calories.title).font(.footnote))")
                Text("\(Image(systemName: Series.distance.symbol)) \(Text(Series.distance.title).font(.footnote))")
                Text("\(Image(systemName: Series.steps.symbol)) \(Text(Series.steps.title).font(.footnote))")
            }
            .font(.system(size: 12, weight: .regular))
            .foregroundStyle(.secondary)
            GridRow {
                Text(Series.calories.string(from: 743226, caption: false))
                Text(Series.distance.string(from: 3900, caption: true)
                    .numeric(font: .body.weight(.semibold).monospacedDigit(),
                             color: .white))
                .font(.callout.weight(.regular))
                .foregroundColor(.white.opacity(0.5))
                Text(Series.steps.string(from: 9746, caption: false))
            }
        }
        .font(.body.weight(.semibold).monospacedDigit())
        .multilineTextAlignment(.center)
        .padding(.bottom, 20)
    }
}
