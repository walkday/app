import WidgetKit
import SwiftUI
import Walker

struct Entry: TimelineEntry {
    let walk: Walk
    let date = Date.now
    let color = [Color.blue, .purple, .indigo, .pink, .orange, .teal, .mint, .cyan].randomElement()!
}
