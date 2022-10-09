import Foundation
import Walker

extension Settings {
    func caption(walk: Walk) -> AttributedString {
        guard stats.content else {
            return AttributedString("No metrics selected")
        }
        
        var result = AttributedString()
        
        if stats.calories {
            result = Series.calories.string(from: walk.calories, caption: true)
            
            if stats.distance || stats.steps {
                result += .init(", ")
            }
        }
        
        if stats.distance {
            result += Series.distance.string(from: walk.distance, caption: true)
            
            if stats.steps {
                result += .init(", ")
            }
        }
        
        if stats.steps {
            result += Series.steps.string(from: walk.steps, caption: true)
        }
        
        return result
    }
}
