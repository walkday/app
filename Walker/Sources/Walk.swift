import Foundation

public struct Walk: Hashable, Comparable, Sendable {
    #warning("test")
    public var steps: Int
    public var calories: Int
    public var distance: Int
    
//    public internal(set) var steps: Int
//    public internal(set) var calories: Int
//    public internal(set) var distance: Int
    public let date: Date
    
    public init() {
        self.init(date: Calendar.current.startOfDay(for: .now))
    }
    
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
