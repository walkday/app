import Foundation

extension Array where Element == Walk {
    mutating public func update(date: Date, element: (inout Element) -> Void) {
        if let index = firstIndex(where: { $0.date == date }) {
            element(&self[index])
        } else {
            var item = Walk(date: date)
            element(&item)
            append(item)
        }
    }
}
