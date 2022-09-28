import SwiftUI

@main
struct App: SwiftUI.App {
    @StateObject private var session = Session()
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            Main(session: session)
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
