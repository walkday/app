import SwiftUI
import Walker

struct Squared: View {
    let entry: Entry
    let series: Series
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack(spacing: 3) {
                Text(series.title)
                    .font(.system(size: 16, weight: .medium))
                Image(systemName: series.symbol)
                    .font(.system(size: 13, weight: .regular))
                Spacer()
            }
            .foregroundStyle(.tertiary)
            
            if let walk = entry.walk {
                Text(series.string(walk: walk)
                    .numeric(font: .system(size: 28, weight: .semibold).monospacedDigit()))
                .font(.system(size: 16, weight: .medium))
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .foregroundStyle(.secondary)
            } else {
                HStack {
                    Capsule()
                        .frame(width: 22, height: 4)
                    Capsule()
                        .frame(width: 22, height: 4)
                    Spacer()
                }
                .padding(.top, 4)
                .foregroundStyle(.tertiary)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .background {
            Color(.tertiarySystemBackground)
        }
    }
}
