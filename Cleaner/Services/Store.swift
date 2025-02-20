//
//  Store.swift
//  Cleaner
//
//  Created by Elena Sedunova on 19.11.2024.
//

import StoreKit

var WEEKLY_PREMIUM_ID = "premium.weekly"

enum StoreError: Error {
    case failedVerification,
         unknowedError
    
    var title: String {
        switch self {
        case .failedVerification: "Failed Verification"
        case .unknowedError: "Unknowed error"
        }
    }
    
    var subtitle: String {
        switch self {
        case .failedVerification: "Your verification is failed"
        case .unknowedError: "Unknowed error"
        }
    }
}

final class Store {
    static var shared = Store()
    
    private(set) var products: [Product] = []
    private let productIds = [WEEKLY_PREMIUM_ID]
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    init() {
        updateListenerTask = listenForTransactions()
        
        Task.init {
            do {
                try await fetchProducts()
            } catch {}
            
            await checkSubscriptionStatus()            
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }

    func fetchProducts() async throws {
        products = try await Product.products(for: productIds)
    }
    
    func purchase() async throws -> Transaction? {
        guard let product = products.first else { return nil }
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            updateCustomerProductStatus(transaction)
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    func checkSubscriptionStatus() async {
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                let productID = transaction.productID
                let expirationDate = transaction.expirationDate
                let isTrial = transaction.offerType == .introductory

                if let expirationDate, expirationDate > Date() {
                    if isTrial {
                        print("\(productID) is active on a **free trial** until \(expirationDate).")
                    } else {
                        print("\(productID) is **actively subscribed (paid)** until \(expirationDate).")
                    }
                } else {
                    print("\(productID) has **expired**.")
                }
            case .unverified(let transaction, let error):
                print("Unverified transaction for \(transaction.productID): \(error.localizedDescription)")
            }
        }
    }
    
    func isTrialNow() async -> Bool {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.offerType == .introductory {
                    return true
                }
            }
        }
        return false
    }
    
    func checkTrialEligibility() async -> Bool {
        guard let product = products.first else { return false }
        return await product.subscription?.isEligibleForIntroOffer ?? false
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    self.updateCustomerProductStatus(transaction)
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification.")
                }
            }
        }
    }
    
    private func updateCustomerProductStatus(_ transaction: Transaction) {
        UserDefaultsService.shared.set(transaction.expirationDate, key: .subscriptionExpirationDate)
    }
}
