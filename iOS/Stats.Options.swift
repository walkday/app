import Foundation

extension Stats {
    final class Options: ObservableObject {
        @Published var calories = true
        @Published var distance = true
        @Published var steps = true
        @Published var challenge = true
        @Published var selected: Walk?
        
        var selection: String? {
            selected
                .map {
                    """
\($0.calories.formatted()) \(Series.calories.title), \
\($0.distance.formatted()) \(Series.distance.title), \
\($0.steps.formatted()) \(Series.steps.title)
"""
                }
        }
    }
}
