import SwiftUI

struct Purchased: View {
    let session: Session
    let dismiss: () -> Void
    
    var body: some View {
        Spacer()
        
        Text("Sponsor")
            .font(.title.weight(.bold))
            .foregroundColor(.white)
        Text("We received your contribution.")
            .font(.body.weight(.regular))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: 320)
            .padding(.top, 5)
        
        Spacer()
        
        Image(systemName: "heart.fill")
            .font(.system(size: 100, weight: .medium))
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(.white)
        
        Spacer()
        
        Button(action: dismiss) {
            Text("Continue")
                .font(.body.weight(.bold))
                .padding(.horizontal)
                .frame(minWidth: 140, minHeight: 30)
        }
        .buttonStyle(.borderedProminent)
        .tint(session.color)
        .foregroundColor(.white)
        
        Spacer()
    }
}
