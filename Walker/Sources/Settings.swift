import Foundation
import Archivable

public struct Settings: Storable, Equatable, Sendable {
    public var challenge: Challenge
    public var iOS: IOS
    public var watchOS: WatchOS
    
    public var data: Data {
        .init()
        .adding(challenge)
        .adding(iOS)
        .adding(watchOS)
    }
    
    public init(data: inout Data) {
        challenge = .init(data: &data)
        iOS = .init(data: &data)
        watchOS = .init(data: &data)
    }
    
    init() {
        challenge = .init()
        iOS = .init()
        watchOS = .init()
    }
}
