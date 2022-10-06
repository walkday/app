import SwiftUI

struct Celebration: View {
    let session: Session
    let dismiss: () -> Void
    
    var body: some View {
        Spacer()
        
        Image(systemName: "trophy.fill")
            .font(.system(size: 80, weight: .ultraLight))
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(.white)
        Text(session.settings.challenge.title
            .numeric(font: .largeTitle.weight(.bold).monospacedDigit(), color: .white))
            .font(.title2.weight(.medium))
            .multilineTextAlignment(.center)
            .frame(maxWidth: 320)
            .foregroundColor(.white)
            .padding(.top, 40)
        Text("Challenge Completed!")
            .font(.title3.weight(.medium))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: 320)
        
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
