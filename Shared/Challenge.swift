import Walker

extension Challenge {
    var title: String {
        "\(value.formatted()) \(series.title)"
    }
}
