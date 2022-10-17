import Foundation
import Archivable

public struct Challenge: Storable, Equatable, Sendable {
    public let series: Series
    public let value: UInt16
    
    public var data: Data {
        .init()
        .adding(series.rawValue)
        .adding(value)
    }
    
    public init(data: inout Data) {
        series = .init(rawValue: data.number())!
        value = data.number()
    }
    
    public init() {
        self = .init(.steps, value: 10000)
    }
    
    public init(_ series: Series, value: UInt16) {
        self.series = series
        self.value = value
    }
}
