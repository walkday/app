import Foundation
import Walker

extension Settings {
    func caption(walk: Walk) -> AttributedString {
        guard iOS.stats.content else {
            return AttributedString("No metrics selected")
        }
        
        var result = AttributedString()
        
        if iOS.stats.calories {
            result = Series.calories.string(from: walk.calories, caption: true)
            
            if iOS.stats.distance || iOS.stats.steps {
                result += .init(", ")
            }
        }
        
        if iOS.stats.distance {
            result += Series.distance.string(from: walk.distance, caption: true)
            
            if iOS.stats.steps {
                result += .init(", ")
            }
        }
        
        if iOS.stats.steps {
            result += Series.steps.string(from: walk.steps, caption: true)
        }
        
        return result
    }
}
