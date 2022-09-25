import SwiftUI

extension AttributedString {
    static func steps(value: Int, caption: Bool) -> Self {
        caption
        ? format(value: value, singular: "step", plural: "steps")
        : plain(value: value)
    }
    
    static func distance(value: Int, caption: Bool) -> Self {
        Measurement(value: .init(value), unit: UnitLength.meters)
            .formatted(.measurement(width: caption ? .abbreviated : .narrow,
                                    usage: .road,
                                    numberFormatStyle: .number
                .precision(.fractionLength(0 ... 1)))
                .attributed)
    }
    
    static func calories(value: Int, caption: Bool) -> Self {
        let value = Int(Double(value) / 1000)
        
        if caption {
            return format(value: value, singular: "calorie", plural: "calories")
        } else {
            return plain(value: value)
        }
    }
    
    func numeric(font: Font, color: Color) -> Self {
        var value = self
        value.runs.forEach { run in
            if run.numberPart != nil || run.numberSymbol != nil {
                value[run.range].foregroundColor = color
                value[run.range].font = font
            }
        }
        return value
    }
    
    private static func plain(value: Int) -> Self {
        var number = Self(value.formatted())
        number.numberPart = .integer
        return number
    }
    
    private static func format(value: Int, singular: String, plural: String) -> Self {
        var number = Self(value.formatted())
        number.numberPart = .integer
        return number + .init(value == 1 ? " " + singular : " " + plural)
    }
}
