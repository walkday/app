import WidgetKit
import Walker

struct Entry: TimelineEntry {
    let walk: Walk
    let percent: Double
    let date = Calendar.current.date(byAdding: .minute, value: 10, to: .now)!
}
