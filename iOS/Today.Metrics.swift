import SwiftUI

extension Today {
    struct Metrics: View {
        @ObservedObject var session: Session
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            VStack(spacing: 0) {
                HStack(alignment: .bottom, spacing: 0) {
                    Text("Today")
                        .font(.title2.weight(.semibold))
                        .padding(.leading)
                    
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24, weight: .regular))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.primary)
                            .frame(width: 56, height: 56)
                            .contentShape(Rectangle())
                    }
                }
                
                Text("Metrics")
                    .font(.body.weight(.regular))
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding(.leading)
                    .padding(.top, 10)
                    .foregroundStyle(.secondary)
                
                Divider()
                    .padding(.vertical, 10)
                
                VStack {
                    Metric(value: $session.settings.tracker.calories, series: .calories)
                    Divider()
                    Metric(value: $session.settings.tracker.distance, series: .distance)
                    Divider()
                    Metric(value: $session.settings.tracker.steps, series: .steps)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .presentationDetents([.medium])
        }
    }
}
