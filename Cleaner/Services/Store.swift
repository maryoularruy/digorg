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
        case .userCancelled: nil
        }
    }
}

final class Store: NSObject {
    static var shared = Store()
    static let productIds = [WEEKLY_PREMIUM_ID]
    
    private(set) var subscriptions: [SKProduct] = []
    private var productRequest: SKProductsRequest?
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    func fetchProducts(productIdentifiers: [String]) {
        let productIdentifiersSet = Set(productIdentifiers)
        productRequest = SKProductsRequest(productIdentifiers: productIdentifiersSet)
        productRequest?.delegate = self
        productRequest?.start()
    }
    
    func purchase(_ product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().add(SKPayment(product: product))
        } else {
            print("User cannot make payments.")
        }
    }
}

extension Store: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased:
                print("purchase success")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred:
                break
            @unknown default:
                break
            }
        }
    }
}

extension Store: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        subscriptions = response.products
    }
    
    func request(_ request: SKRequest, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
}
