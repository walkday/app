import Foundation
import Archivable

public struct Settings: Storable, Equatable, Sendable {
    public var challenge: Challenge
    public var tracker: Metrics
    public var stats: Metrics
    public var watch: Metrics
    public var goal: Bool
    
    public var data: Data {
        .init()
        .adding(challenge)
        .adding(tracker)
        .adding(stats)
        .adding(watch)
        .adding(goal)
    }
    
    public init(data: inout Data) {
        challenge = .init(data: &data)
        tracker = .init(data: &data)
        stats = .init(data: &data)
        watch = .init(data: &data)
        goal = data.bool()
    }
    
    init() {
        challenge = .init()
        tracker = .init()
        stats = .init()
        watch = .init()
        goal = true
    }
}
