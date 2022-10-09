import SwiftUI
import CloudKit
import Walker
import Archivable

final class Session: ObservableObject, @unchecked Sendable {
    @Published var settings = Settings()
    @Published private(set) var walks = [Walk]()
    let color: Color
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.WalkDay")
    let health = Health()
    
    init() {
        color = [Color.blue, .purple, .indigo, .pink, .orange, .teal, .mint, .cyan].randomElement()!
        
        cloud
            .map(\.settings)
            .removeDuplicates()
            .assign(to: &$settings)
        
        Task { [weak self] in
            try? await health
                .begin { [weak self] in
                    self?.walks ?? []
                } write: { [weak self] walks in
                    if self?.walks.isEmpty == true && !walks.isEmpty {
                        withAnimation(.easeInOut(duration: 0.3)) { [weak self] in
                            self?.walks = walks
                        }
                    } else {
                        self?.walks = walks
                    }
                }
        }
    }
    
    var percent: Double {
        walks
            .last
            .map {
                settings.challenge.percent(walk: $0)
            }
        ?? 0
    }
}
