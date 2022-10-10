import WidgetKit
import Walker
import CloudKit
import Combine
import Archivable

final class Provider: TimelineProvider, @unchecked Sendable {
    private var entry = Entry(walk: .init(steps: 100), percent: 1)
    private var walks = [Walk]()
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
        
        Task { [weak self] in
            try? await health
                .begin { [weak self] items, keyPath in
                    guard let self else { return }
                    let walks = self.walks.update(items: items, keyPath: keyPath)
                    self.walks = walks
                    guard let last = walks.last else { return }
                    self.entry = .init(walk: last, percent: self.challenge.percent(walk: last))
                }
        }
    }
    
    func placeholder(in: Context) -> Entry {
        entry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        cloud.pull.send()
        completion(.init(entries: [entry],
                         policy: .after(Calendar.current.date(byAdding: .minute, value: 1, to: .now)!)))
    }
}
