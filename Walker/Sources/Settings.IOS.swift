import Foundation
import Archivable

extension Settings {
    public struct IOS: Storable, Equatable, Sendable {
        public var tracker: Metrics
        public var stats: Metrics
        public var widget: Metrics
        public var goal: Bool
        
        public var data: Data {
            .init()
            .adding(tracker)
            .adding(stats)
            .adding(widget)
            .adding(goal)
        }
        
        public init(data: inout Data) {
            tracker = .init(data: &data)
            stats = .init(data: &data)
            widget = .init(data: &data)
            goal = data.bool()
        }
        
        init() {
            tracker = .init()
            stats = .init()
            widget = .init()
            goal = true
        }
    }
}
