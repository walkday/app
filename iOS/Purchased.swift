import SwiftUI

struct Purchased: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Image(systemName: "heart.fill")
                .font(.system(size: 70, weight: .regular))
                .symbolRenderingMode(.multicolor)
            
            Spacer()
            
            Text("Sponsor")
                .font(.title.weight(.bold))
            Text("We received your contribution.")
                .font(.body.weight(.regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 320)
                .padding(.top, 5)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("OK")
                    .font(.body.weight(.bold))
                    .padding(.horizontal)
                    .frame(minWidth: 140, minHeight: 30)
            }
            .buttonStyle(.borderedProminent)
            .tint(.accentColor)
            .foregroundColor(.white)
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .presentationDetents([.medium])
    }
}
