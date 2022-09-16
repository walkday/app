import SwiftUI
import StoreKit

struct Preferences: View {
    @Environment(\.requestReview) private var review
    
    var body: some View {
        VStack {
            ShareLink("", item: URL(string: "https://www.swanspotting.com")!)
            Button {
                review()
            } label: {
                Text("Review")
            }
            Spacer()
        }
    }
}
