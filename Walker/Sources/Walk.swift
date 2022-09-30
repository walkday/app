import Foundation

public struct Walk: Hashable, Comparable, Sendable {
    public var steps: Int
    public var calories: Int
    public var distance: Int
    public let date: Date
    
    public init(date: Date, steps: Int = 0, calories: Int = 0, distance: Int = 0) {
        self.steps = steps
        self.calories = calories
        self.distance = distance
        self.date = date
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.date < rhs.date
    }
}
