import Foundation
import Archivable

extension Settings {
    public struct WatchOS: Storable, Equatable, Sendable {
        public var tracker: Metrics
        public var widget: Metrics
        
        public var data: Data {
            .init()
            .adding(tracker)
            .adding(widget)
        }
        
        public init(data: inout Data) {
            tracker = .init(data: &data)
            widget = .init(data: &data)
        }
        
        public init() {
            tracker = .init()
            widget = .init()
        }
    }
}
