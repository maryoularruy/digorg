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
    var updateListenerTask: Task<Void, Error>? = nil
    private let productIds = ["premium.weekly"]
    private(set) var subscriptions: [Product] = []
    private(set) var purchasedSubscriptions: [Product] = []
    
    init() {
        updateListenerTask = listenForTransactions()
        Task {
            await getProducts()
            await updateCustomerProductStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func purchase(_ product: Product) async throws -> Result<Transaction, Error> {
        switch try await product.purchase() {
        case let .success(.verified(transaction)):
            await deliverContent(for: transaction)
            await updateCustomerProductStatus()
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
    
    private func getProducts() async {
        do {
            let storeProducts = try await Product.products(for: productIds)

            for product in storeProducts {
                switch product.type {
                case .consumable: break
                case .nonConsumable: break
                case .autoRenewable: subscriptions.append(product)
                case .nonRenewable: break
                default: break
                }
            }
        } catch {
            print("Failed product request from the App Store server. \(error)")
        }
    }
    
    private func updateCustomerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                
                switch transaction.productType {
                case .nonConsumable: break
                case .nonRenewable: break
                case .autoRenewable:
                    if let subscription = subscriptions.first(where: { $0.id == transaction.productID }) {
                        purchasedSubscriptions.append(subscription)
                    }
                default: break
                }
            } catch { break }
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
