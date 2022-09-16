import SwiftUI

struct Overview: View {
    let color: Color
    @State private var stats = false
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(LinearGradient(colors: [color.opacity(0.15),
                                              color.opacity(0.05)],
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing)
                    )
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.white.opacity(0.3).shadow(.inner(color: .white, radius: 1)))
            
            Button {
                stats = true
            } label: {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(.clear)
            }
            .padding(.vertical, 20)
            .sheet(isPresented: $stats) {
                Text("Hello")
                    .presentationDetents([.fraction(0.5)])
            }
        }
        .shadow(color: color.opacity(0.5), radius: 4)
        .padding(.horizontal)
    }
}
