import Foundation
import StoreKit

@Observable
final class SubscriptionService {

    var isPremium: Bool = false
    var availableProducts: [Product] = []
    var purchaseInProgress: Bool = false
    var purchaseError: Error?

    private var transactionListener: Task<Void, Error>?

    init() {
        transactionListener = listenForTransactions()
        Task { await refreshStatus() }
    }

    deinit {
        transactionListener?.cancel()
    }

    // MARK: - Public API

    @MainActor
    func loadProducts() async {
        do {
            let productIDs = [Constants.StoreKit.monthlyProductID, Constants.StoreKit.annualProductID]
            availableProducts = try await Product.products(for: productIDs)
                .sorted { $0.price < $1.price }
        } catch {
            // Products unavailable in sandbox/simulator — treat gracefully
        }
    }

    @MainActor
    func purchase(_ product: Product) async {
        purchaseInProgress = true
        purchaseError = nil
        defer { purchaseInProgress = false }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await updatePremiumStatus()
                await transaction.finish()
            case .userCancelled:
                break
            case .pending:
                break
            @unknown default:
                break
            }
        } catch {
            purchaseError = error
        }
    }

    @MainActor
    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePremiumStatus()
        } catch {
            purchaseError = error
        }
    }

    // MARK: - Private

    private func listenForTransactions() -> Task<Void, Error> {
        Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updatePremiumStatus()
                    await transaction.finish()
                } catch {
                    // Invalid transaction — ignore
                }
            }
        }
    }

    @MainActor
    private func refreshStatus() async {
        await updatePremiumStatus()
    }

    @MainActor
    private func updatePremiumStatus() async {
        let productIDs: Set<String> = [Constants.StoreKit.monthlyProductID, Constants.StoreKit.annualProductID]
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result),
               productIDs.contains(transaction.productID) {
                isPremium = true
                return
            }
        }
        isPremium = false
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    enum StoreError: Error {
        case failedVerification
    }
}
