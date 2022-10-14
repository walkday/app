import WidgetKit
import Walker

struct Entry: TimelineEntry {
    let walk: Walk
    let percent: Double
    let date = Date.now
}
