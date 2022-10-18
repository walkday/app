import WidgetKit
import Walker

struct Entry: TimelineEntry {
    #warning("test")
    init(walk: Walk? = nil, challenge: Challenge = .init(), error: Error? = nil) {
        self.walk = walk
        self.challenge = challenge
        self.error = error
    }
    
    let walk: Walk?
    let challenge: Challenge
    let error: Error?
    let date = Date.now
    
    var percent: Double {
        if let walk {
            return challenge.percent(walk: walk)
        } else {
            return 0
        }
    }
}
