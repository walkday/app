import SwiftUI

extension Today {
    struct Metrics: View {
        @ObservedObject var session: Session
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            NavigationStack {
                List {
                    Section("Metrics") {
                        Metric(value: $session.settings.tracker.calories, series: .calories)
                        Metric(value: $session.settings.tracker.distance, series: .distance)
                        Metric(value: $session.settings.tracker.steps, series: .steps)
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
