import SwiftUI
import WidgetKit

@main
struct App: SwiftUI.App {
    @StateObject private var session = Session()
    @State private var selection = Int()
    @Environment(\.scenePhase) private var phase
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                Main(session: session)
                Goal(session: session)
                Preferences(session: session)
            }
        }
        .backgroundTask(.appRefresh("Widget")) {
            WidgetCenter.shared.reloadAllTimelines()
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
                break
            }
        }
    }
}
