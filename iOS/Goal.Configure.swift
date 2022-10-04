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
                Picker("Metric", selection: $series.animation(.easeInOut(duration: 0.3))) {
                    ForEach(Series.allCases, id: \.self) { series in
                        Image(systemName: series.symbol)
                            .tag(series)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, 24)
                .padding(.horizontal)
                
                Text(series.string(from: .init(value), caption: true)
                    .numeric(font: .title.weight(.medium).monospacedDigit(), color: .primary))
                    .font(.title3.weight(.regular))
                    .foregroundColor(.secondary)
                    .padding(.top, 40)
                    .padding(.bottom)
                
                Slider(value: $value.animation(.easeInOut(duration: 0.15)), in: series.range, step: step)
                    .padding(.horizontal)
                
                Spacer()
                
                Button {
                    Task {
                        await session.cloud.update(settings: session.settings.challenge(series: series, value: value))
                    }
                    
                    dismiss()
                } label: {
                    Text("Save")
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                }
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
            .background(series.color.opacity(0.4).gradient, ignoresSafeAreaEdges: .all)
            .presentationDetents([.fraction(0.5)])
            .onChange(of: series) { newValue in
                if value < newValue.range.lowerBound {
                    value = newValue.range.lowerBound
                } else if value > newValue.range.upperBound {
                    value = newValue.range.upperBound
                }
            }
            .task {
                series = session.settings.challenge.series
                value = .init(session.settings.challenge.value)
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
