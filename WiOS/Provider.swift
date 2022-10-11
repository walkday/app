import WidgetKit
import SwiftUI
import Walker
import CloudKit
import Combine
import Archivable

final class Provider: TimelineProvider, @unchecked Sendable {
    let color = [Color.blue, .purple, .indigo, .pink, .orange, .teal, .mint, .cyan].randomElement()!
    
    private var walks = [Walk]() {
        didSet {
            refresh.send()
        }
    }
    
    private var challenge = Challenge()
    private var subs = Set<AnyCancellable>()
    private let refresh = PassthroughSubject<Void, Never>()
    private let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.WalkDay")
    private let health = Health(days: 1)
    
    init() {
        cloud
            .map(\.settings.challenge)
            .removeDuplicates()
            .sink { [weak self] in
                self?.challenge = $0
                self?.refresh.send()
            }
            .store(in: &subs)
        
        Task { [weak self] in
            await health
                .begin { [weak self] items, keyPath in
                    guard let self else { return }
                    let walks = self.walks.update(items: items, keyPath: keyPath, limit: 1)
                    self.walks = walks
                }
        }
        
        refresh
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink {
                WidgetCenter.shared.reloadAllTimelines()
            }
            .store(in: &subs)
    }
    
    func placeholder(in: Context) -> Entry {
        .init(walk: .init(), percent: 0)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(.init(walk: .init(), percent: 0))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        cloud.pull.send()
        let last = walks.last ?? .init()
        completion(.init(entries: [.init(walk: last, percent: challenge.percent(walk: last))], policy: .atEnd))
    }
}
