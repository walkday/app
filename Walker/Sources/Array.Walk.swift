import Foundation

extension Array where Element == Walk {
    mutating public func update(items: [Date : Int], keyPath: WritableKeyPath<Element, Int>) {
        items
            .forEach { item in
                if let index = firstIndex(where: { $0.date == item.key }) {
                    self[index][keyPath: keyPath] = item.value
                } else {
                    var walk = Walk(date: item.key)
                    walk[keyPath: keyPath] = item.value
                    append(walk)
                }
            }
    }
}
