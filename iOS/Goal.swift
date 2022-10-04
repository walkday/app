import SwiftUI

struct Goal: View {
    @ObservedObject var session: Session
    @State private var configure = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            heading
            
            Spacer()
            
            current
            
            Spacer()
            
            action
            
            Spacer()
        }
        .background(session.settings.challenge.series.color.opacity(0.25).gradient, ignoresSafeAreaEdges: .all)
        .presentationDetents([.fraction(0.6)])
    }
    
    private var heading: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text("Challenge")
                .font(.title2.weight(.semibold))
                .padding(.leading)
            
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24, weight: .regular))
                    .symbolRenderingMode(.hierarchical)
                    .frame(width: 56, height: 56)
                    .contentShape(Rectangle())
            }
        }
    }
    
    private var current: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(session.settings.challenge.series.color)
                    
                Image(systemName: session.settings.challenge.series.symbol)
                    .font(.system(size: 26, weight: .regular))
                    .foregroundColor(.white)
            }
            .frame(width: 54, height: 54)
            
            Text(session.settings.challenge.title
                .numeric(font: .title2.weight(.medium).monospacedDigit(), color: .primary))
                .font(.body.weight(.regular))
                .foregroundColor(.secondary)
        }
    }
    
    private var action: some View {
        Button("Configure") {
            configure = true
        }
        .fontWeight(.semibold)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .sheet(isPresented: $configure) {
            Configure(session: session)
        }
    }
}
