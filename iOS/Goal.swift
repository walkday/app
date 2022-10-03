import SwiftUI

struct Goal: View {
    let session: Session
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            heading
                .background(Color(.tertiarySystemBackground), ignoresSafeAreaEdges: .all)
            Divider()
            
            Spacer()
        }
        .background(Color(.secondarySystemBackground), ignoresSafeAreaEdges: .all)
        .presentationDetents([.fraction(0.5)])
    }
    
    private var heading: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text("Challenge")
                .font(.title2.weight(.semibold))
                .padding(.leading)
                .padding(.bottom, 10)
            
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
}
