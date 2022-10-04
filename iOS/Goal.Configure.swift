import SwiftUI

extension Goal {
    struct Configure: View {
        @ObservedObject var session: Session
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            VStack(spacing: 0) {
                
            }
            .presentationDetents([.fraction(0.5)])
        }
    }
}
