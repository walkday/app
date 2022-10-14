import SwiftUI

struct Background: View {
    private let color = [Color.blue, .purple, .indigo, .pink, .orange, .teal, .mint, .cyan].randomElement()!
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white)
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(LinearGradient(colors: [color,
                                              color.opacity(0.6)],
                                     startPoint: .top,
                                     endPoint: .bottom)
                    .shadow(.inner(color: .white, radius: 1)))
        }
        .ignoresSafeArea(edges: .all)
    }
}
