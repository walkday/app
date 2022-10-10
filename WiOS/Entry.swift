import WidgetKit
import SwiftUI
import Walker

struct Entry: TimelineEntry {
    let walk: Walk
    let percent: Double
    let color = [Color.blue, .purple, .indigo, .pink, .orange, .teal, .mint, .cyan].randomElement()!
    let date = Date.now
}
