import SwiftUI

extension Stats {
    struct Metrics: View {
        @ObservedObject var session: Session
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            NavigationStack {
                List {
                    Section("Configure metrics") {
                        Metric(value: $session.settings.stats.calories, series: .calories)
                            .padding(.vertical, 1.5)
                        Metric(value: $session.settings.stats.distance, series: .distance)
                            .padding(.vertical, 1.5)
                        Metric(value: $session.settings.stats.steps, series: .steps)
                            .padding(.vertical, 1.5)
                    }
                    .headerProminence(.increased)
                }
                .navigationTitle("Today")
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
            .presentationDetents([.medium])
        }
    }
}