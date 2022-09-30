import Foundation
import Walker

extension Settings {
    func caption(walk: Walk) -> AttributedString {
        var result = AttributedString()
        
        if calories {
            result = Series.calories.string(from: walk.calories, caption: true)
            
            if distance || steps {
                result += .init(", ")
            }
        }
        
        if distance {
            result += Series.distance.string(from: walk.distance, caption: true)
            
            if steps {
                result += .init(", ")
            }
        }
        
        if steps {
            result += Series.steps.string(from: walk.steps, caption: true)
        }
        
        return result
    }
}
