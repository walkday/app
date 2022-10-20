import SwiftUI
import WidgetKit

@main
struct App: SwiftUI.App {
    @StateObject private var session = Session()
    @AppStorage("sounds") private var sounds = true
    @AppStorage("vibrations") private var vibrations = true
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            Main(session: session)
                .task {
                    delegate.session = session
                    let session = session
                    
                    Task
                        .detached {
                            await session.store.launch()
                        }
                    
                    WidgetCenter.shared.reloadAllTimelines()
                }
        }
        .onChange(of: phase) {
            switch $0 {
            case .active:
                session.cloud.pull.send()
                
                if sounds {
                    session.activateSound()
                }
                
                if vibrations {
                    session.activeHaptics()
                }
                
                UserDefaults.standard.setValue(false, forKey: "sponsor")
                
                WidgetCenter.shared.reloadAllTimelines()
            default:
                break
            }
        }
    }
}
