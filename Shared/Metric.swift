import SwiftUI
import Walker

struct Metric: View {
    @Binding var value: Bool
    let series: Series
    
    var body: some View {
        Toggle(isOn: $value.animation(.easeInOut)) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(value ? series.color : .init(white: 0, opacity: 0.1))
                        
                    Image(systemName: series.symbol)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white)
                }
                .frame(width: 37, height: 37)
                
                Text(series.title)
                    .font(.callout.weight(.regular))
                Spacer()
            }
        }
        .tint(series.color)
    }
}
