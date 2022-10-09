import Foundation
import Archivable

public struct Settings: Storable, Equatable, Sendable {
    public var challenge: Challenge
    public var iOSTracker: Metrics
    public var iOSStats: Metrics
    public var iOSWidget: Metrics
    public var watchOSTracker: Metrics
    public var watchOSWidget: Metrics
    
    public var data: Data {
        .init()
        .adding(challenge)
        .adding(iOSTracker)
        .adding(iOSStats)
        .adding(iOSWidget)
        .adding(watchOSTracker)
        .adding(watchOSWidget)
    }
    
    public init(data: inout Data) {
        challenge = .init(data: &data)
        iOSTracker = .init(data: &data)
        iOSStats = .init(data: &data)
        iOSWidget = .init(data: &data)
        watchOSTracker = .init(data: &data)
        watchOSWidget = .init(data: &data)
    }
    
    public init() {
        challenge = .init(.steps, value: 5000)
        iOSTracker = .init()
        iOSStats = .init()
        iOSWidget = .init()
        watchOSTracker = .init()
        watchOSWidget = .init()
    }
    
    public func challenge(series: Series, value: Double) -> Self {
        var settings = self
        settings.challenge = .init(series, value: .init(value))
        return settings
    }
}
