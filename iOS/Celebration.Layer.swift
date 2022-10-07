import SwiftUI

extension Celebration {
    struct Layer: View, Equatable {
        private let model = Model()

        var body: some View {
            TimelineView(.periodic(from: .now, by: 0.01)) { timeline in
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
                                              endAngle: .radians(.pi * 2),
                                              clockwise: false)
                                }, with: .color(.white.opacity(particle.opacity)))
                        }
                }
            }
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            true
        }
    }
}

private final class Model {
    private(set) var particles = Set<Particle>()
    
    func tick(date: Date, size: CGSize) {
        var particles = particles
            .compactMap {
                $0.tick()
            }
        
        if Int.random(in: 0 ..< 3) == 0 {
            particles.append(.init(radius: .random(in: 0.6 ... 20),
                                   x: .random(in: 20 ..< (size.width - 20)),
                                   y: .random(in: 20 ..< (size.height - 20)),
                                   opacity: .random(in: 0.035 ..< 0.97),
                                   decrease: .random(in: 1.000015 ..< 1.05)))
        }
        
        self.particles = .init(particles)
    }
}

private struct Particle: Hashable {
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
