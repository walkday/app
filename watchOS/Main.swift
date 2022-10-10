import SwiftUI

struct Main: View {
    @ObservedObject var session: Session
    
    var body: some View {
        ScrollView {
            if let last = session.walks.last {
                Tracker(walk: last,
                        percent: session.percent,
                        color: session.color,
                        metrics: session.settings.tracker)
            } else {
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
            }
        }
        .background {
            LinearGradient(stops: [.init(color: session.color.opacity(0.95), location: 0),
                                   .init(color: session.color.opacity(0.5), location: 0.4),
                                   .init(color: session.color.opacity(0.4), location: 0.5),
                                   .init(color: session.color.opacity(0.3), location: 1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
        }
    }
}
