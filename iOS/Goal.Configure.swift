import SwiftUI
import Walker

extension Goal {
    struct Configure: View {
        @ObservedObject var session: Session
        @State private var series = Series.calories
        @State private var value = CGFloat()
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            VStack(spacing: 0) {
                Picker("Metric", selection: $series) {
                    ForEach(Series.allCases, id: \.self) { series in
                        Image(systemName: series.symbol)
                            .tag(series)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, 24)
                .padding(.horizontal)
                
                Text(series.title)
                    .font(.title2.weight(.semibold))
                    .padding(.top, 40)
                
                Slider(value: $value, in: range, step: step)
                    .padding()
                
                Text(value, format: .number)
                    .font(.title3.weight(.medium).monospacedDigit())
                
                Spacer()
                
                Button("Save") {
                    
                }
                .fontWeight(.semibold)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(.primary)
                .foregroundColor(.init(.systemBackground))
                
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.secondary)
                .padding(.vertical, 20)
            }
            .background(session.settings.challenge.series.color.opacity(0.25).gradient, ignoresSafeAreaEdges: .all)
            .presentationDetents([.fraction(0.5)])
            .onChange(of: series) { newValue in
                
            }
            .task {
                series = session.settings.challenge.series
                value = .init(session.settings.challenge.value)
            }
        }
        
        private var range: ClosedRange<CGFloat> {
            switch series {
            case .calories:
                return 100 ... 5000
            case .distance:
                return 1000 ... 20000
            case .steps:
                return 1000 ... 20000
            }
        }
        
        private var step: CGFloat {
            switch series {
            case .calories:
                return 100
            case .distance:
                return 500
            case .steps:
                return 500
            }
        }
    }
}
