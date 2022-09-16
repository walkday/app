import SwiftUI

struct Tracker: View {
    let color: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.white)
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(LinearGradient(colors: [color, color.opacity(0.6)],
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing)
                    .shadow(.inner(color: .white, radius: 1)))
            
            VStack(spacing: 0) {
                Text("78\(Text(verbatim: "%").font(.system(size: 20, weight: .regular)).baselineOffset(24).foregroundColor(.init(.systemBackground).opacity(0.6)))")
                    .font(.system(size: 60, weight: .semibold).monospacedDigit())
                    .padding(.top, 20)
                Text("You are doing great!")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                ZStack(alignment: .leading) {
                    Capsule()
                        .foregroundStyle(.tertiary)
                    Capsule()
                        .frame(width: 200)
                }
                .frame(height: 3)
                .padding(.vertical, 25)
                .padding(.horizontal, 20)
                
                Grid(horizontalSpacing: 20) {
                    GridRow {
                        Text("\(Image(systemName: "flame")) Calories")
                        Text("\(Image(systemName: "ruler")) Distance")
                        Text("\(Image(systemName: "figure.step.training")) Steps")
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
            .padding(18)
        }
        .foregroundColor(.init(.systemBackground))
        .shadow(color: color.opacity(0.4), radius: 4)
        .padding(.horizontal)
        .fixedSize(horizontal: false, vertical: true)
    }
}
