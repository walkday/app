import WidgetKit
import Walker

struct Entry: TimelineEntry {
    let walk: Walk?
    let challenge: Challenge
    let date = Date.now
}
