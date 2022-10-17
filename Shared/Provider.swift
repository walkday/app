import WidgetKit
import Walker

final class Provider: TimelineProvider {
    func placeholder(in: Context) -> Entry {
        .init(walk: nil, challenge: .init())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(.init(walk: nil, challenge: .init()))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        Task {
            do {
                let walk = try await Health.today
                completion(entry(walk: walk, minutes: 30))
            } catch {
                completion(entry(walk: nil, minutes: 5))
            }
        }
    }
    
    private var challenge: Challenge {
        if var data = UserDefaults(suiteName: "group.walkday.share")!.object(forKey: "challenge") as? Data,
           !data.isEmpty {
            return .init(data: &data)
        } else {
            return .init()
        }
    }
    
    private func entry(walk: Walk?, minutes: Int) -> Timeline<Entry> {
        .init(entries: [.init(walk: walk, challenge: challenge)],
                         policy: .after(Calendar.current.date(byAdding: .minute, value: minutes, to: .now)!))
    }
}
