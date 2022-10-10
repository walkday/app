import Foundation
import Walker

extension Settings.Metrics {
    func caption(walk: Walk) -> AttributedString {
        guard content else {
            return AttributedString("No metrics selected")
        }
        
        var result = AttributedString()
        
        if calories {
            result = Series.calories.string(from: walk.calories)
            
            if distance || steps {
                result += .init(", ")
            }
        }
        
        if distance {
            result += Series.distance.string(from: walk.distance)
            
            if steps {
                result += .init(", ")
            }
        }
        
        if steps {
            result += Series.steps.string(from: walk.steps)
        }
        
        return result
    }
}
