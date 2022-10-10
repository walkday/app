import Foundation
import Walker

extension Challenge {
    var title: AttributedString {
        series.string(from: .init(value))
    }
    
    func challenged(walk: Walk) -> Int {
        switch series {
        case .calories:
            return min(walk.calories, .init(value))
        case .distance:
            return min(walk.distance, .init(value))
        case .steps:
            return min(walk.steps, .init(value))
        }
    }
    
    func achieved(walk: Walk) -> Bool {
        switch series {
        case .calories:
            return walk.calories >= .init(value)
        case .distance:
            return walk.distance >= .init(value)
        case .steps:
            return walk.steps >= .init(value)
        }
    }
    
    func partial(walk: Walk) -> Int {
        let value = Int(value)
        let ratio = value / 6
        
        switch series {
        case .calories:
            return max(min(walk.calories, value) - ratio, 0)
        case .distance:
            return max(min(walk.distance, value) - ratio, 0)
        case .steps:
            return max(min(walk.steps, value) - ratio, 0)
        }
    }
    
    func activeMin(walk: Walk) -> Int {
        let value = Int(value)
        let ratio = value / 10
        
        switch series {
        case .calories:
            return max(min(walk.calories, value) - ratio, 0)
        case .distance:
            return max(min(walk.distance, value) - ratio, 0)
        case .steps:
            return max(min(walk.steps, value) - ratio, 0)
        }
    }
    
    func activeMax(walk: Walk) -> Int {
        let value = Int(value)
        let ratio = value / 10
        
        switch series {
        case .calories:
            return min(walk.distance + ratio, value)
        case .distance:
            return min(walk.distance + ratio, value)
        case .steps:
            return min(walk.steps + ratio, value)
        }
    }
    
    func percent(walk: Walk) -> Double {
        switch series {
        case .calories:
            return min(1, .init(walk.calories) / .init(value))
        case .distance:
            return min(1, .init(walk.distance) / .init(value))
        case .steps:
            return min(1, .init(walk.steps) / .init(value))
        }
    }
}
