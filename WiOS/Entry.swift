import WidgetKit
import SwiftUI
import Walker

struct Entry: TimelineEntry {
    let walk: Walk
    let percent = 0.8
    let color = [Color.blue, .purple, .indigo, .pink, .orange, .teal, .mint, .cyan].randomElement()!
    let date = Date.now
}
