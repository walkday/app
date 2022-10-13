import SwiftUI

extension Stats {
    struct Metrics: View {
        @ObservedObject var session: Session
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            NavigationStack {
                List {
                    Section("Metrics") {
                        Metric(value: $session.settings.stats.calories, series: .calories)
                        Metric(value: $session.settings.stats.distance, series: .distance)
                        Metric(value: $session.settings.stats.steps, series: .steps)
                    }
                    .headerProminence(.increased)
                    
                    Section("Challenge") {
                        Toggle(isOn: $session.settings.goal.animation(.easeInOut)) {
                            HStack(spacing: 12) {
                                Text("Show")
                                    .font(.callout.weight(.regular))
                                Spacer()
                            }
                        }
                        .tint(session.challenge.series.color)
                    }
                    .headerProminence(.increased)
                }
                .navigationTitle("Past 14 days")
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
