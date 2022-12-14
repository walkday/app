import StoreKit
import Combine

final class Store {
    enum Status: Equatable {
        case
        loading,
        ready,
        error(String)
    }
    
    enum Item: String, CaseIterable {
        case
        sponsor = "walkday.sponsor"
    }
    
    let status = CurrentValueSubject<Status, Never>(.ready)
    let purchased = PassthroughSubject<Void, Never>()
    private var products = [Item : Product]()
    
    func launch() async {
        for await result in Transaction.updates {
            if case let .verified(safe) = result {
                await process(transaction: safe)
            }
        }
    }
    
    func entitlements() async {
        guard UserDefaults.standard.value(forKey: "sponsor") as? Bool != true else { return }
        for await result in Transaction.currentEntitlements {
            if case let .verified(safe) = result {
                await process(transaction: safe)
            }
        }
    }
    
    func load(item: Item) async -> Product? {
        guard let product = products[item] else {
            guard let product = try? await Product.products(for: [item.rawValue]).first else { return nil }
            products[item] = product
            return product
        }
        return product
    }
    
    func purchase(_ product: Product) async {
        status.send(.loading)

        do {
            switch try await product.purchase() {
            case let .success(verification):
                if case let .verified(safe) = verification {
                    await process(transaction: safe)
                    status.send(.ready)
                } else {
                    status.send(.error("Purchase verification failed."))
                }
            case .pending:
                status.send(.error("Purchase is pending..."))
            default:
                status.send(.ready)
            }
        } catch let storeError as StoreKitError {
            switch storeError {
            case .userCancelled:
                break
            case .notEntitled:
                status.send(.error("Can't purchase at this moment"))
            case .notAvailableInStorefront:
                status.send(.error("Product not available"))
            case let .networkError(error):
                status.send(.error(error.localizedDescription))
            case let .systemError(error):
                status.send(.error(error.localizedDescription))
            default:
                status.send(.error("Unknown error, try again later"))
            }
        } catch {
            status.send(.error(error.localizedDescription))
        }
    }
    
    func restore() async {
        status.send(.loading)
        try? await AppStore.sync()
        await entitlements()
        status.send(.ready)
    }
    
    func purchase(legacy: SKProduct) async {
        guard let product = try? await Product.products(for: [legacy.productIdentifier]).first else { return }
        await purchase(product)
    }
    
    private func process(transaction: Transaction) async {
        guard
            let item = Item(rawValue: transaction.productID),
            item == .sponsor
        else { return }
        
        if transaction.revocationDate == nil {
            UserDefaults.standard.setValue(true, forKey: "sponsor")
            await purchase()
        } else {
            UserDefaults.standard.setValue(false, forKey: "sponsor")
        }
        
        await transaction.finish()
    }
    
    @MainActor private func purchase() {
        purchased.send()
    }
}
