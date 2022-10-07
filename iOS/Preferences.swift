import SwiftUI
import StoreKit

struct Preferences: View {
    let session: Session
    @AppStorage("celebrate") private var celebrate = true
    @AppStorage("vibrations") private var vibrations = true
    @AppStorage("sounds") private var sounds = true
    @Environment(\.requestReview) private var review
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                sponsor
                goals
                privacy
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
            NavigationLink(destination: Sponsor(session: session)) {
                Label("Sponsor Walk Day", systemImage: "heart")
                    .symbolRenderingMode(.multicolor)
            }
        }
    }
    
    @MainActor private var goals: some View {
        Section("Daily goals") {
            Toggle(isOn: $celebrate.animation(.easeInOut(duration: 0.3))) {
                Label("Celebrate", systemImage: "trophy")
                    .symbolRenderingMode(.multicolor)
            }
            .tint(session.color)
            
            if celebrate {
                Toggle(isOn: $vibrations) {
                    Label("Vibrations", systemImage: "iphone.radiowaves.left.and.right")
                        .symbolRenderingMode(.multicolor)
                }
                .tint(session.color)
                Toggle(isOn: $sounds) {
                    Label("Sounds", systemImage: "speaker")
                        .symbolRenderingMode(.multicolor)
                }
                .tint(session.color)
            }
        }
        .headerProminence(.increased)
    }
    
    @MainActor private var privacy: some View {
        Section("Privacy") {
            Link(destination: .init(string: UIApplication.openSettingsURLString)!) {
                Label("Walk Day settings", systemImage: "gear")
                    .symbolRenderingMode(.multicolor)
            }
        }
        .headerProminence(.increased)
    }
    
    @MainActor private var app: some View {
        Section("Walk Day") {
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
