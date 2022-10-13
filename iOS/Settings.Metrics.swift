import Foundation
import Walker

extension Settings.Metrics {
    func caption(walk: Walk) -> AttributedString {
        guard content else { return AttributedString("No metrics selected") }
        
        var result = AttributedString()
        
        if let calories = append(walk: walk, series: .calories, separator: distance || steps) {
            result += calories
        }
        
        if let distance = append(walk: walk, series: .distance, separator: steps) {
            result += distance
        }
        
        if let steps = append(walk: walk, series: .steps, separator: false) {
            result += steps
        }
        
        return result
    }
    
    private func append(walk: Walk, series: Series, separator: Bool) -> AttributedString? {
        guard self[keyPath: series.metric] else { return nil }
        var result = series.challenge(walk: walk)
        
        if separator {
            if distance || steps {
                result += .init(", ")
            }
        }
        
        return result
    }
}
