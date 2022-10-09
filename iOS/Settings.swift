import Foundation
import Walker

extension Settings {
    func caption(walk: Walk) -> AttributedString {
        guard iOSStats.content else {
            return AttributedString("No metrics selected")
        }
        
        var result = AttributedString()
        
        if iOSStats.calories {
            result = Series.calories.string(from: walk.calories, caption: true)
            
            if iOSStats.distance || iOSStats.steps {
                result += .init(", ")
            }
        }
        
        if iOSStats.distance {
            result += Series.distance.string(from: walk.distance, caption: true)
            
            if iOSStats.steps {
                result += .init(", ")
            }
        }
        
        if iOSStats.steps {
            result += Series.steps.string(from: walk.steps, caption: true)
        }
        
        return result
    }
}
