import SwiftUI

struct Progress: Shape {
    var value: Double

    func path(in rect: CGRect) -> Path {
        .init {
            $0.addArc(center: .init(x: rect.midX, y: rect.midY),
                      radius: radius(rect: rect),
                      startAngle: .degrees(-220),
                      endAngle: .degrees(-220 + (260 * value)),
                      clockwise: false)
        }
    }

    var animatableData: Double {
        get {
            value
        }
        set {
            value = newValue
        }
    }
    
    private func radius(rect: CGRect) -> CGFloat {
        min(rect.midX, rect.midY) - 6
    }
}
