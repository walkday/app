import SwiftUI

struct Card: ViewModifier {
    var fill: Color?
    private let base = RoundedRectangle(cornerRadius: 26, style: .continuous)
    
    func body(content: Content) -> some View {
        ZStack {
            base
                .fill(Color(.tertiarySystemBackground))
            
            if let fill {
                base
                    .fill(LinearGradient(colors: [fill, fill.opacity(0.6)],
                                         startPoint: .topLeading,
                                         endPoint: .bottomTrailing)
                        .shadow(.inner(color: .white, radius: 1)))
            }
            
            content
                .padding(18)
        }
        .shadow(color: fill == nil ? .init(white: 0, opacity: 0.4) : fill!.opacity(0.4), radius: 4)
        .padding(.horizontal)
    }
}
