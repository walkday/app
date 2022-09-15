import SwiftUI

struct Main: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    Text("78\(Text(verbatim: "%").font(.system(size: 20, weight: .regular)).baselineOffset(24).foregroundColor(.white.opacity(0.6)))")
                        .font(.system(size: 60, weight: .semibold).monospacedDigit())
                        .foregroundColor(.white)
                        .padding(.vertical, 60)
                        .modifier(Card(fill: .blue))
                        .padding(.top)
                }
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
        }
        .background {
            LinearGradient(colors: [.blue.opacity(0.4), .blue.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
        }
    }
}
