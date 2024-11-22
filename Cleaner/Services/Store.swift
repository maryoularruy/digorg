//
//  Store.swift
//  Cleaner
//
//  Created by Elena Sedunova on 19.11.2024.
//

import StoreKit

public enum StoreError: Error {
    case failedVerification,
         waitingOnSCAOrBuyApproval,
         unknowedError,
         userCancelled
    
    var isShowAlert: Bool {
        switch self {
        case .failedVerification: true
        case .waitingOnSCAOrBuyApproval: false
        case .unknowedError: true
        case.userCancelled: false
        }
    }
    
    var title: String? {
        switch self {
        case .failedVerification: "Failed Verification"
        case .waitingOnSCAOrBuyApproval: nil
        case .unknowedError: "Unknowed error"
        case.userCancelled: nil
        }
    }
    
    var subtitle: String? {
        switch self {
        case .failedVerification: "Your verification is failed"
        case .waitingOnSCAOrBuyApproval: nil
        case .unknowedError: "Unknowed error"
        case.userCancelled: nil
        }
    }
}

final class Store {
    static var shared = Store()
    
    var updateListenerTask: Task<Void, Error>? = nil
    private let productIds = ["premium.weekly"]
    
    init() {
        self.updateListenerTask = listenForTransactions()
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func getProducts() async throws -> [Product] {
        try await Product.products(for: productIds)
    }
    
    func purchase(_ product: Product) async throws -> Result<Transaction, Error> {
        switch try await product.purchase() {
        case let .success(.verified(transaction)):
            await deliverContent(for: transaction)
            await transaction.finish()
            return .success(transaction)
            
        case .success(.unverified):
            return .failure(StoreError.failedVerification)
        case .pending:
            return .failure(StoreError.waitingOnSCAOrBuyApproval)
        case .userCancelled:
            return .failure(StoreError.userCancelled)
        @unknown default:
            return .failure(StoreError.unknowedError)
        }
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.deliverContent(for: transaction)
                    await transaction.finish()
                } catch(let error) {
                    print("Transaction failed verification: \(error)")
                }
            }
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    private func deliverContent(for transaction: Transaction) async {
        print("Delivering content for product \(transaction.productID)")
    }
}
