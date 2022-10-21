import WidgetKit
import Walker

struct Provider: TimelineProvider, Sendable {
    func placeholder(in: Context) -> Entry {
        .init(walk: walk, challenge: challenge ?? .init())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(.init(walk: walk, challenge: challenge ?? .init()))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        Task {
            let walk: Walk?
            do {
                walk = try await Health.today
                if let walk {
                    UserDefaults(suiteName: "group.walkday.share")!.set(walk.data, forKey: "walk")
                }
            } catch {
                walk = self.walk
            }
            completion(.init(entries: [.init(walk: walk, challenge: challenge ?? .init())],
                             policy: .after(Calendar.current.date(byAdding: .minute, value: 35, to: .now)!)))
        }
    }
    
    private var walk: Walk? {
        if var data = UserDefaults(suiteName: "group.walkday.share")!.object(forKey: "walk") as? Data,
           !data.isEmpty {
            return .init(data: &data)
        }
        return nil
    }
    
    private var challenge: Challenge? {
        if var data = UserDefaults(suiteName: "group.walkday.share")!.object(forKey: "challenge") as? Data,
           !data.isEmpty {
            return .init(data: &data)
        }
        return nil
    }
}
