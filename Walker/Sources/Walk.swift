import Archivable
import Foundation

public struct Walk: Storable, Hashable, Comparable, Sendable {
    public internal(set) var steps: Int
    public internal(set) var calories: Int
    public internal(set) var distance: Int
    public let date: Date

    public init() {
        self.init(date: Calendar.current.startOfDay(for: .now))
    }
    
    public var data: Data {
        .init()
        .adding(UInt16(steps))
        .adding(UInt16(calories))
        .adding(UInt16(distance))
        .adding(date)
    }
    
    public init(data: inout Data) {
        steps = .init(data.number() as UInt16)
        calories = .init(data.number() as UInt16)
        distance = .init(data.number() as UInt16)
        date = data.date()
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
