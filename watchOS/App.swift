import SwiftUI
import WidgetKit

@main
struct App: SwiftUI.App {
    @StateObject private var session = Session()
    @State private var selection = Int()
    @Environment(\.scenePhase) private var phase
    @WKApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                Main(session: session)
                Goal(session: session)
                Preferences(session: session)
            }
            .task {
                delegate.session = session
                await session.connect()
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .onChange(of: phase) {
            switch $0 {
            case .active:
                session.cloud.pull.send()
                
                Task {
                    await session.connect()
                }
                
                WidgetCenter.shared.reloadAllTimelines()
            default:
                Task {
                    await session.disconnect()
                }
            }
        }
    }
}
