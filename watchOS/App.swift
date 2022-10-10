import SwiftUI

@main
struct App: SwiftUI.App {
    @StateObject private var session = Session()
    @State private var selection = Int()
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                Main(session: session)
                Preferences(session: session)
            }
        }
    }
}
