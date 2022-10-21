import SwiftUI
import WidgetKit
import BackgroundTasks

@main
struct App: SwiftUI.App {
    @StateObject private var session = Session()
    @AppStorage("sounds") private var sounds = true
    @AppStorage("vibrations") private var vibrations = true
    @Environment(\.scenePhase) private var phase
    
    var body: some Scene {
        WindowGroup {
            Main(session: session)
        }
        .backgroundTask(.appRefresh("Widget")) {
            let request = BGAppRefreshTaskRequest(identifier: "Widget")
            request.earliestBeginDate = Calendar.current.date(byAdding: .minute, value: 20, to: .now)
            try? BGTaskScheduler.shared.submit(request)
            
            WidgetCenter.shared.reloadAllTimelines()
        }
        .onChange(of: phase) {
            switch $0 {
            case .active:
                session.cloud.pull.send()

                Task {
                    await session.connect()
                }
                
                if sounds {
                    session.activateSound()
                }

                if vibrations {
                    session.activeHaptics()
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
