import WidgetKit
import Walker

final class Provider: TimelineProvider {
    func placeholder(in: Context) -> Entry {
        .init(walk: walk, percent: challenge.percent(walk: walk))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(.init(walk: walk, percent: challenge.percent(walk: walk)))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        Task {
            do {
                let walk = try await Health.today
                self.walk = walk
                completion(entry(walk: walk, minutes: 30))
            } catch {
                completion(entry(walk: self.walk, minutes: 10))
            }
        }
    }
    
    private func entry(walk: Walk, minutes: Int) -> Timeline<Entry> {
        .init(entries: [.init(walk: walk, percent: challenge.percent(walk: walk))],
                         policy: .after(Calendar.current.date(byAdding: .minute, value: minutes, to: .now)!))
    }
}
