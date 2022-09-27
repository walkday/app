import Foundation
import Archivable

public struct Preferences: Storable, Equatable {
    public internal(set) var challenge: Challenge
    public internal(set) var calories: Bool
    public internal(set) var distance: Bool
    public internal(set) var steps: Bool
    public internal(set) var goal: Bool
    
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
    
    init() {
        challenge = .init(.steps, value: 5000)
        calories = true
        distance = true
        steps = true
        goal = true
    }
}
