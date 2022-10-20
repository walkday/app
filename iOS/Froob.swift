import SwiftUI
import StoreKit

struct Froob: View {
    @ObservedObject var session: Session
    @State private var alert = false
    @State private var error = ""
    @State private var product: Product?
    
    var body: some View {
        VStack {
            Text("Contribute\nto Walk Day.")
                .foregroundColor(session.color)
                .multilineTextAlignment(.center)
                .font(.callout.weight(.medium))
                .fixedSize(horizontal: false, vertical: true)
            
            Button {
                guard session.store.status.value == .ready else { return }
                
                if let product = product {
                    Task {
                        await session.store.purchase(product)
                    }
                } else {
                    session.store.status.value = .error("Unable to connect to the App Store, try again later.")
                }
            } label: {
                Text("Sponsor")
                    .font(.callout.weight(.semibold))
                    .padding(.horizontal)
                    .frame(minWidth: 160, minHeight: 30)
            }
            .buttonStyle(.borderedProminent)
            .tint(session.color)
            .foregroundColor(.white)
            
            if let product = product {
                Text("1 time purchase of " + product.displayPrice)
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(session.color)
                    .frame(maxWidth: 260)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .alert(error, isPresented: $alert) { }
        .onReceive(session.store.status.receive(on: DispatchQueue.main)) {
            switch $0 {
            case let .error(fail):
                error = fail
                alert = true
            default:
                break
            }
        }
        .task {
            product = await session.store.load(item: .sponsor)
        }
    }
}
