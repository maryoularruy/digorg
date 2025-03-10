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
         networkError,
         unknowedError
    
    var title: String {
        switch self {
        case .failedVerification: "Failed Verification"
        case .networkError: "Network Error"
        case .unknowedError: "Unknowed error"
        }
    }
    
    var subtitle: String {
        switch self {
        case .failedVerification: "Your verification is failed"
        case .networkError: "Check your network connection and try again"
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
    
    func purchase() async throws {
        if products.isEmpty {
            try await fetchProducts()
            try await purchaseProduct()
        } else {
            try await purchaseProduct()
        }
    }
    
    private func purchaseProduct() async throws {
        guard let product = products.first else { throw StoreError.networkError }
        
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            updateCustomerProductStatus(transaction)
        case .userCancelled, .pending:
            return
        default:
            return
        }
    }
    
    func restore(completion: @escaping (Bool) -> Void) throws {
        Task {
            do {
                var restored = false
                for await result in Transaction.currentEntitlements {
                    switch result {
                    case .verified(let transaction):
                        if transaction.revocationDate == nil {
                            restored = true
                        }
                    case .unverified(_, let error):
                        throw error
                    }
                }
                completion(restored)
            } catch {
                throw error
            }
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
    
    func isTrialEligible() async -> Bool {
        guard let product = products.first else { return false }
        return await product.subscription?.isEligibleForIntroOffer ?? false
    }
    
    func isAutoRenew() async -> Bool {
        guard let product = products.first else { return false }
        
        do {
            guard let status = try await product.subscription?.status.first else { return false }
            return try status.renewalInfo.payloadValue.willAutoRenew
        } catch {
            return false
        }
    }
    
    func getSubscriptionPrice() -> String {
        guard let product = products.first else { return "" }
        return "\(product.displayPrice) / week"
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
