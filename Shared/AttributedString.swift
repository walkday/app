import SwiftUI

extension AttributedString {
    static func plain(value: Int) -> Self {
        var number = Self(value.formatted())
        number.numberPart = .integer
        return number
    }
    
    static func format(value: Int, singular: String, plural: String) -> Self {
        var number = Self(value.formatted())
        number.numberPart = .integer
        return number + .init(value == 1 ? " " + singular : " " + plural)
    }
    
    static func distance(value: Int) -> Self {
        Measurement(value: .init(value), unit: UnitLength.meters)
            .formatted(.measurement(width: .abbreviated,
                                    usage: .road,
                                    numberFormatStyle: .number
                .precision(.fractionLength(0 ... 1)))
                .attributed)
    }
    
    static func calories(value: Int) -> Self {
        Measurement(value: .init(value), unit: UnitEnergy.kilocalories)
            .formatted(.measurement(width: .abbreviated,
                                    usage: .workout,
                                    numberFormatStyle: .number).attributed)
    }
    
    func numeric(font: Font, color: Color? = nil) -> Self {
        var value = self
        value.runs.forEach { run in
            if run.numberPart != nil || run.numberSymbol != nil {
                if let color {
                    value[run.range].foregroundColor = color
                }
                value[run.range].font = font
            }
        }
        return value
    }
}
