import Foundation

public struct Walk: Hashable, Comparable, Sendable {
    
    #warning("test")
    public init(steps: Int = 0, calories: Int = 0, distance: Int = 0, date: Date = .now) {
        self.steps = steps
        self.calories = calories
        self.distance = distance
        self.date = date
    }
    
    public var steps: Int
    public var calories: Int
    public var distance: Int
    public let date: Date
    
    init(date: Date) {
        self.steps = 0
        self.calories = 0
        self.distance = 0
        self.date = date
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.date < rhs.date
    }
}
