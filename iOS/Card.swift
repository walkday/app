import SwiftUI

struct Card: ViewModifier {
    let fill: Color
    private let base = RoundedRectangle(cornerRadius: 30, style: .continuous)
    
    func body(content: Content) -> some View {
        ZStack {
            base
                .fill(Color(.tertiarySystemBackground))
            
            base
                .fill(LinearGradient(colors: [fill, fill.opacity(0.6)],
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing)
                    .shadow(.inner(color: .white, radius: 1)))
            
            content
                .padding(18)
        }
        .foregroundColor(Color(.systemBackground))
        .shadow(color: fill.opacity(0.4), radius: 4)
        .padding(.horizontal)
    }
}
