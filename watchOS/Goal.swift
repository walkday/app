import SwiftUI
import Walker

struct Goal: View {
    @ObservedObject var session: Session
    @State private var series = Series.calories
    @State private var value = CGFloat()
    
    var body: some View {
        ScrollView {
            Picker("Metric", selection: $series) {
                ForEach(Series.allCases, id: \.self) { series in
                    HStack {
                        Text(series.title)
                        Image(systemName: series.symbol)
                    }
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 70)
            .padding(.horizontal)
            
            Text(series.challenge(value: .init(value))
                .numeric(font: .title3.weight(.medium).monospacedDigit(), color: .primary))
                .font(.body.weight(.regular))
                .foregroundColor(.secondary)
                .padding(.vertical)
            
            Slider(value: $value.animation(.easeInOut(duration: 0.15)), in: series.range, step: series.step)
                .padding()
            
            Button {
                Task {
                    await session.cloud.update(challenge: series, value: value)
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
            series = session.challenge.series
            value = .init(session.challenge.value)
        }
    }
}
