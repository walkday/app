import SwiftUI
import CloudKit
import Walker
import Archivable

final class Session: ObservableObject, @unchecked Sendable {
    @Published var challenge = Challenge()
    @Published var settings = Settings.WatchOS()
    @Published private(set) var walks = [Walk]()
    let color: Color
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.WalkDay")
    let health = Health()
    
    init() {
        color = [Color.blue, .purple, .indigo, .pink, .orange, .teal, .mint, .cyan].randomElement()!
        
        cloud
            .map(\.settings.watchOS)
            .removeDuplicates()
            .assign(to: &$settings)
        
        cloud
            .map(\.settings.challenge)
            .removeDuplicates()
            .assign(to: &$challenge)
        
        Task { [weak self] in
            try? await health
                .begin { [weak self] items, keyPath in
                    guard let self else { return }
                    let walks = self.walks.update(items: items, keyPath: keyPath)
                    
                    if self.walks.isEmpty == true && !walks.isEmpty {
                        withAnimation(.easeInOut(duration: 0.3)) { [weak self] in
                            self?.walks = walks
                        }
                    } else {
                        self.walks = walks
                    }
                }
        }
    }
    
    var percent: Double {
        walks
            .last
            .map {
                challenge.percent(walk: $0)
            }
        ?? 0
    }
}
