import SwiftUI

struct Main: View {
    @ObservedObject var session: Session
    
    var body: some View {
        ScrollView {
            if session.walks.isEmpty {
                if session.health.available {
                    Text("Loading\nhealth data...")
                        .font(.callout.weight(.semibold))
                        .padding()
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    Text("Walk Day needs to be allowed to access Apple Health.")
                        .font(.footnote.weight(.regular))
                        .padding([.leading, .trailing, .bottom])
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                } else {
                    Text("Apple Health not available")
                        .font(.callout.weight(.semibold))
                        .padding()
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                
            } else {
                Tracker.Gauge(percent: session.percent)
                    .padding(.horizontal, 20)
                    .frame(height: 150)
                
                if let walk = session.walks.last, session.settings.tracker.content {
                    Stats(session: session, walk: walk)
                }
            }
        }
        .background {
            LinearGradient(stops: [.init(color: session.color, location: 0),
                                   .init(color: session.color.opacity(0.6), location: 1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
        }
    }
}
