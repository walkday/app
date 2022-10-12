import Foundation
import Walker

extension Challenge {
    func progress(walk: Walk) -> Int {
        min(.init(value), walk[keyPath: series.keyPath])
    }
    
    func achieved(walk: Walk) -> Bool {
        walk[keyPath: series.keyPath] >= .init(value)
    }
    
    func percent(walk: Walk) -> Double {
        min(1, .init(walk[keyPath: series.keyPath]) / .init(value))
    }
}
