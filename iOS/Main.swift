import SwiftUI

struct Main: View {
    var body: some View {
        VStack(spacing: 0) {
            Tracker(color: .blue)
                .padding(.top, 25)
            
            Overview(color: .blue)
                .padding(.top, 50)
                .padding(.bottom, 30)
            
            Spacer()
            
            Options()
                .padding(.bottom, 35)
        }
        .background {
            LinearGradient(stops: [.init(color: .blue.opacity(0.95), location: 0),
                                   .init(color: .blue.opacity(0.5), location: 0.4),
                                   .init(color: .blue.opacity(0.4), location: 0.5),
                                   .init(color: .blue.opacity(0.3), location: 1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
        }
    }
}
