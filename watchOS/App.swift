import SwiftUI

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
                Preferences(session: session)
            }
            .task {
                delegate.session = session
            }
        }
        .onChange(of: phase) {
            switch $0 {
            case .active:
                session.cloud.pull.send()
            default:
                break
            }
        }
    }
}
