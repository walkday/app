import SwiftUI
import Walker

struct Goal: View {
    @ObservedObject var session: Session
    @State private var series = Series.calories
    @State private var value = CGFloat()
    
    var body: some View {
        ScrollView {
            Picker("Metric", selection: $series) {
                ForEach(Series.allCases, id: \.self) { serie in
                    Label(serie.title, systemImage: serie.symbol)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 60)
            .padding(.horizontal)
            
            Text(series.challenge(value: .init(value))
                .numeric(font: .title2.weight(.medium).monospacedDigit(), color: .primary))
                .font(.body.weight(.regular))
                .foregroundColor(.secondary)
                .padding(.vertical)
            
            Slider(value: $value.animation(.easeInOut(duration: 0.15)), in: series.range, step: series.step)
                .padding()
            
            if series != session.challenge.series || value != .init(session.challenge.value) {
                Button("Reset") {
                    reset()
                }
                .buttonStyle(.plain)
                .foregroundColor(.secondary)
                .padding()
                .padding(.vertical)
            }
            
            Button {
                Task {
                    await session.cloud.update(challenge: .init(series, value: .init(value)))
                }
            } label: {
                Text("Save")
                    .fontWeight(.semibold)
                    .padding(.horizontal)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(.white)
            .foregroundColor(.black)
            .padding()
            .padding(.horizontal)
        }
        .onChange(of: series) { newValue in
            if value < newValue.range.lowerBound {
                value = newValue.range.lowerBound
            } else if value > newValue.range.upperBound {
                value = newValue.range.upperBound
            }
        }
        .task {
            reset()
        }
    }
    
    private func reset() {
        series = session.challenge.series
        value = .init(session.challenge.value)
    }
}
