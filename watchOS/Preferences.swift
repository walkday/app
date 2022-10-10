import SwiftUI

struct Preferences: View {
    @ObservedObject var session: Session
    
    var body: some View {
        VStack {
            Text("Settings")
        }
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background {
            LinearGradient(stops: [.init(color: session.color.opacity(0.95), location: 0),
                                   .init(color: session.color.opacity(0.5), location: 0.4),
                                   .init(color: session.color.opacity(0.4), location: 0.5),
                                   .init(color: session.color.opacity(0.3), location: 1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
        }
    }
}
