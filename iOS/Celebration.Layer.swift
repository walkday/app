import SwiftUI

private let pi2 = Double.pi * 2

extension Celebration {
    struct Layer: View {
        private let model = Model()

        var body: some View {
            TimelineView(.periodic(from: .now, by: 0.02)) { timeline in
                Canvas { context, size in
                    model.tick(date: timeline.date, size: size)
                    model
                        .particles
                        .forEach { particle in
                            context
                                .fill(.init {
                                    $0.addArc(center: .init(x: particle.x, y: particle.y),
                                              radius: particle.radius,
                                              startAngle: .radians(0),
                                              endAngle: .radians(pi2),
                                              clockwise: false)
                                }, with: .color(.white.opacity(particle.opacity)))
                        }
                }
            }
//            .accessibilityLabel("Logo animating")
        }

//        static func == (lhs: Self, rhs: Self) -> Bool {
//            true
//        }
    }
}

private final class Model {
    private(set) var particles = [Particle]()
    
    init() {
        print("init")
    }
    
    func tick(date: Date, size: CGSize) {
        particles = particles.tick(width: size.width, height: size.height)
    }
}


struct Particle {
    let radius: Double
    let x: Double
    let y: Double
    let opacity: Double
    private let decrease: Double
    
    init(radius: Double, x: Double, y: Double, opacity: Double, decrease: Double) {
        self.radius = radius
        self.x = x
        self.y = y
        self.opacity = opacity
        self.decrease = decrease
    }
    
    func tick() -> Self? {
        radius > 0.15 ? .init(radius: radius / decrease, x: x, y: y, opacity: opacity, decrease: decrease) : nil
    }
}


extension Array where Element == Particle {
    func tick(width: Double, height: Double) -> Self {
        var particles = self
            .compactMap {
                $0.tick()
            }
        
        if Int.random(in: 0 ..< 6) == 0 {
            particles.append(.init(radius: .random(in: 0.6 ... 20),
                                   x: .random(in: 20 ..< (width - 20)),
                                   y: .random(in: 20 ..< (height - 20)),
                                   opacity: .random(in: 0.035 ..< 0.97),
                                   decrease: .random(in: 1.000015 ..< 1.05)))
        }
        
        return particles
    }
}
