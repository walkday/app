import SwiftUI

struct Card: ViewModifier {
    var fill: Color?
    
    func body(content: Content) -> some View {
        ZStack {
            Rectangle()
                .fill(Color(.tertiarySystemBackground))
            
            if let fill {
                Rectangle()
                    .fill(LinearGradient(colors: [fill, fill.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
            }
            
            content
                .padding(18)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: fill == nil ? .init(white: 0, opacity: 0.3) : fill!.opacity(0.7), radius: 5, y: 2)
        .padding(.horizontal)
    }
}
