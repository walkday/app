import SwiftUI

extension Today {
    struct Metrics: View {
        @ObservedObject var session: Session
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            NavigationStack {
                List {
                    Section("Metrics") {
                        Metric(value: $session.settings.iOS.tracker.calories, series: .calories)
                            .padding(.vertical, 2)
                        Metric(value: $session.settings.iOS.tracker.distance, series: .distance)
                            .padding(.vertical, 2)
                        Metric(value: $session.settings.iOS.tracker.steps, series: .steps)
                            .padding(.vertical, 2)
                    }
                    .headerProminence(.increased)
                }
                .navigationTitle("Configure")
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
