import SwiftUI

struct Main: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text(verbatim: "Hello world")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .modifier(Card(fill: .blue))
                    .padding(.top)
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
        }
        .background {
            LinearGradient(colors: [.blue.opacity(0.5), .blue.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
        }
    }
}
