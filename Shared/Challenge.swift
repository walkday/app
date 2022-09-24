struct Challenge {
    let value: Int
    let series: Series
    
    var title: String {
        "\(value.formatted()) \(series.title)"
    }
}
