import WidgetKit
import Walker

struct Entry: TimelineEntry {
    let walk: Walk?
    let challenge: Challenge
    let date = Date.now
    
    var percent: Double {
        if let walk {
            return challenge.percent(walk: walk)
        } else {
            return 0
        }
    }
}
