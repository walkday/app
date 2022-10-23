import SwiftUI
import WidgetKit

struct Main: View {
    @ObservedObject var session: Session
    @WKApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some View {
        ScrollView {
            if session.walks.isEmpty {
                Text("Loading\nhealth data...")
                    .font(.callout.weight(.semibold))
                    .padding()
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                Text("Walk Day needs to be allowed to access Apple Health.")
                    .font(.footnote.weight(.regular))
                    .padding([.leading, .trailing, .bottom])
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            } else {
                Tracker.Gauge(percent: session.percent)
                    .padding(.horizontal, 10)
                    .frame(height: 140)
                
                if let walk = session.walks.last, session.settings.tracker.content {
                    Stats(session: session, walk: walk)
                }
            }
        }
        .onAppear {
            Task {
                await session.connect()
            }
        }
        .task {
            delegate.session = session
            await session.connect()
            WidgetCenter.shared.reloadAllTimelines()
        }
        .background {
            LinearGradient(stops: [.init(color: session.color, location: 0),
                                   .init(color: session.color.opacity(0.6), location: 1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
        }
    }
}
