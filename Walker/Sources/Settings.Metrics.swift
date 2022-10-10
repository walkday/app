import Foundation
import Archivable

extension Settings {
    public struct Metrics: Storable, Equatable, Sendable {
        public var calories: Bool
        public var distance: Bool
        public var steps: Bool
        
        public var content: Bool {
            calories || distance || steps
        }
        
        public var data: Data {
            .init()
            .adding(calories)
            .adding(distance)
            .adding(steps)
        }
        
        public init(data: inout Data) {
            calories = data.bool()
            distance = data.bool()
            steps = data.bool()
        }
        
        #warning("test")
        public init() {
            calories = true
            distance = true
            steps = true
        }
    }
}
