import Foundation
import Walker

extension Stats {
    final class Options: ObservableObject {
        @Published var calories = true
        @Published var distance = true
        @Published var steps = true
        @Published var challenge = true
        @Published var selected: Walk?
        
        var selection: AttributedString {
            (Series.calories.string(from: selected!.calories, caption: true)
             + .init(", ") + Series.distance.string(from: selected!.distance, caption: true)
             + .init(", ") + Series.steps.string(from: selected!.steps, caption: true))
            .numeric(font: .callout, color: .secondary)
        }
    }
}
