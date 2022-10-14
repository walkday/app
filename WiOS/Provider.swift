import WidgetKit
import SwiftUI
import Walker
import CloudKit
import Combine
import Archivable

final class Provider: TimelineProvider, @unchecked Sendable {
    static let shared = Provider()
    static let color = [Color.blue, .purple, .indigo, .pink, .orange, .teal, .mint, .cyan].randomElement()!
    #warning("test")
//    private var walk = Walk(steps: 3000, calories: 2340, distance: 1500)
    private var walk = Walk()
    private var challenge = Challenge()
    private var subs = Set<AnyCancellable>()
    private let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.WalkDay")
    private let health = Health()
    
    init() {
        cloud
            .map(\.settings.challenge)
            .removeDuplicates()
            .sink { [weak self] in
                self?.challenge = $0
            }
            .store(in: &subs)
    }
    
    func placeholder(in: Context) -> Entry {
        .init(walk: walk, percent: challenge.percent(walk: walk))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(.init(walk: walk, percent: challenge.percent(walk: walk)))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        Task {
            do {
                let walk = try await health.today
                self.walk = walk
                completion(entry(walk: walk, minutes: 10))
            } catch {
                completion(entry(walk: self.walk, minutes: 1))
            }
        }
    }
    
    private func entry(walk: Walk, minutes: Int) -> Timeline<Entry> {
        .init(entries: [.init(walk: walk, percent: challenge.percent(walk: walk))],
                         policy: .after(Calendar.current.date(byAdding: .minute, value: minutes, to: .now)!))
    }
}
