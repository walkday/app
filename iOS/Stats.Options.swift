import Foundation

extension Stats {
    final class Options: ObservableObject {
        @Published var calories = true
        @Published var distance = true
        @Published var steps = true
        @Published var challenge = true
        @Published var selected: Walk?
    }
}
