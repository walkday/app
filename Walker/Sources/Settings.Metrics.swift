import Foundation
import Archivable

extension Settings {
    public struct Metrics: Storable, Equatable, Sendable {
        public var calories: Bool
        public var distance: Bool
        public var steps: Bool
        public var goal: Bool
        
        public var content: Bool {
            calories || distance || steps
        }
        
        public var data: Data {
            .init()
            .adding(calories)
            .adding(distance)
            .adding(steps)
            .adding(goal)
        }
        
        public init(data: inout Data) {
            calories = data.bool()
            distance = data.bool()
            steps = data.bool()
            goal = data.bool()
        }
        
        init() {
            calories = true
            distance = true
            steps = true
            goal = true
        }
    }
}
