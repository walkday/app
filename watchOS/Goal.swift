import SwiftUI

struct Goal: View {
    @ObservedObject var session: Session
    @State private var configure = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Challenge")
                .font(.title3.weight(.medium))
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .padding(.bottom)
            
            Spacer()
            
            Text(session.challenge.series.challenge(value: .init(session.challenge.value))
                .numeric(font: .system(.title2, weight: .semibold).monospacedDigit(), color: .primary))
            .font(.system(.footnote, weight: .regular))
            .foregroundColor(.secondary)
            
            Spacer()
            
            Button {
                configure = true
            } label: {
                Text("Configure")
                    .fontWeight(.semibold)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .sheet(isPresented: $configure) {
                Configure(session: session)
            }
        }
        .padding(.horizontal)
    }
}
