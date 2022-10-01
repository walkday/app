import SwiftUI

struct Main: View {
    @ObservedObject var session: Session
    
    var body: some View {
        VStack(spacing: 0) {
            if let last = session.walks.last {
                Tracker(walk: last, percent: session.percent, color: session.color)
                    .padding(.top, 25)
            }
            
            Overview(session: session)
                .padding(.top, 50)
                .padding(.bottom, 30)
            
            Spacer()
            
            Options(session: session)
                .padding(.bottom, 35)
        }
        .background {
            LinearGradient(stops: [.init(color: session.color.opacity(0.95), location: 0),
                                   .init(color: session.color.opacity(0.5), location: 0.4),
                                   .init(color: session.color.opacity(0.4), location: 0.5),
                                   .init(color: session.color.opacity(0.3), location: 1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
        }
        .onChange(of: session.settings) { settings in
            Task {
                await session.cloud.update(settings: settings)
            }
        }
    }
}
