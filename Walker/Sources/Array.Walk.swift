import Foundation

extension Array where Element == Walk {
    public func update(items: [Date : Int], keyPath: WritableKeyPath<Element, Int>, limit: Int) -> Self {
        var result = self
        
        items
            .forEach { item in
                if let index = result.firstIndex(where: { $0.date == item.key }) {
                    result[index][keyPath: keyPath] = item.value
                } else {
                    var walk = Walk(date: item.key)
                    walk[keyPath: keyPath] = item.value
                    result.append(walk)
                }
            }
        
        return result
            .sorted()
            .suffix(limit)
    }
}
