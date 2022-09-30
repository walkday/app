import Foundation
import Archivable

public struct Settings: Storable, Equatable, Sendable {
    public var challenge: Challenge
    public var calories: Bool
    public var distance: Bool
    public var steps: Bool
    public var goal: Bool
    
    public var data: Data {
        .init()
        .adding(challenge)
        .adding(calories)
        .adding(distance)
        .adding(steps)
        .adding(goal)
    }
    
    public init(data: inout Data) {
        challenge = .init(data: &data)
        calories = data.bool()
        distance = data.bool()
        steps = data.bool()
        goal = data.bool()
    }
    
    public init() {
        challenge = .init(.steps, value: 5000)
        calories = true
        distance = true
        steps = true
        goal = true
    }
}
