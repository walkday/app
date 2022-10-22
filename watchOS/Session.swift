import SwiftUI
import CloudKit
import Combine
import Walker
import Archivable

final class Session: ObservableObject, @unchecked Sendable {
    @Published var challenge = Challenge()
    @Published var settings = Settings()
    @Published private(set) var walks = [Walk]()
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.WalkDay")
    let color = Color.random
    private var health: Health?
    private var subs = Set<AnyCancellable>()
    
    init() {
        cloud
            .map(\.settings)
            .removeDuplicates()
            .assign(to: &$settings)
        
        cloud
            .map(\.settings.challenge)
            .removeDuplicates()
            .sink { [weak self] challenge in
                UserDefaults(suiteName: "group.walkday.share")!.setValue(challenge.data, forKey: "challenge")
                self?.challenge = challenge
            }
            .store(in: &subs)
    }
    
    var percent: Double {
        walks
            .last
            .map {
                challenge.percent(walk: $0)
            }
        ?? 0
    }
    
    @MainActor func connect() async {
        guard health == nil else { return }
        health = .init()
        
        try? await health!.auth()
        
        await health!
            .begin { [weak self] items, keyPath in
                guard let self else { return }
                self.walks = self.walks.update(items: items, keyPath: keyPath)
            }
    }
    
    @MainActor func disconnect() {
        health = nil
    }
}
