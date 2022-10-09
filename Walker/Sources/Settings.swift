import Foundation
import Archivable

public struct Settings: Storable, Equatable, Sendable {
    public var challenge: Challenge
    public var tracker: Metrics
    public var stats: Metrics
    
    public var data: Data {
        .init()
        .adding(challenge)
        .adding(tracker)
        .adding(stats)
    }
    
    public init(data: inout Data) {
        challenge = .init(data: &data)
        tracker = .init(data: &data)
        stats = .init(data: &data)
    }
    
    public init() {
        challenge = .init(.steps, value: 5000)
        tracker = .init()
        stats = .init()
    }
    
    public func challenge(series: Series, value: Double) -> Self {
        var settings = self
        settings.challenge = .init(series, value: .init(value))
        return settings
    }
}
