import SwiftUI
import StoreKit

struct Preferences: View {
    @Environment(\.requestReview) private var review
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                sponsor
                health
                app
            }
            .navigationTitle("Preferences")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    private var sponsor: some View {
        Section {
            NavigationLink(destination: Circle()) {
                Label("Sponsor Walk Day", systemImage: "heart")
                    .symbolRenderingMode(.multicolor)
            }
        }
    }
    
    @MainActor private var health: some View {
        Section("Settings") {
            Link(destination: .init(string: UIApplication.openSettingsURLString)!) {
                Label("Walk Day settings", systemImage: "gear")
                    .symbolRenderingMode(.multicolor)
            }
        }
        .headerProminence(.increased)
    }
    
    @MainActor private var app: some View {
        Section("App") {
            NavigationLink(destination: About()) {
                Label("About", systemImage: "figure.walk")
                    .symbolRenderingMode(.multicolor)
            }
            
            ShareLink("Share", item: URL(string: "https://apps.apple.com/us/app/walkday/id1645073003?platform=iphone")!)
                .symbolRenderingMode(.multicolor)
            
            
            Link(destination: .init(string: "https://apps.apple.com/app/id1645073003?action=write-review")!) {
                Label("Review on the App Store", systemImage: "star")
                    .symbolRenderingMode(.multicolor)
            }
        }
        .headerProminence(.increased)
    }
}
