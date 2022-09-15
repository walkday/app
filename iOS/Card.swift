import SwiftUI

struct Card: ViewModifier {
    var fill: Color?
    
    func body(content: Content) -> some View {
        ZStack {
            Rectangle()
                .fill(Color(.tertiarySystemBackground))
            
            if let fill {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(LinearGradient(colors: [fill, fill.opacity(0.6)],
                                         startPoint: .topLeading,
                                         endPoint: .bottomTrailing)
                        .shadow(.inner(color: .white, radius: 1)))
            }
            
            content
                .padding(18)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: fill == nil ? .init(white: 0, opacity: 0.4) : fill!.opacity(0.4), radius: 4)
        .padding(.horizontal)
    }
}
