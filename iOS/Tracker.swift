import SwiftUI

struct Tracker: View {
    let color: Color
    
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
            .padding(18)
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
            .fill(LinearGradient(colors: [color, color.opacity(0.6)],
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
        Grid(horizontalSpacing: 20, verticalSpacing: 4) {
            GridRow {
                Text("\(Image(systemName: "flame.fill")) Calories")
                Text("\(Image(systemName: "app.connected.to.app.below.fill")) Distance")
                Text("\(Image(systemName: "figure.run")) Steps")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            GridRow {
                Text("300")
                Text("1,9km")
                Text("546")
            }
        }
        .font(.body.weight(.semibold).monospacedDigit())
        .multilineTextAlignment(.center)
        .padding(.bottom, 20)
    }
}
