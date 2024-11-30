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
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func checkUserSubscription() {
        guard let receiptData = getAppReceipt() else { return }
        let receiptString = receiptData.base64EncodedString()
        
        validateReceipt(receiptData: receiptString, isSandbox: false) { [weak self] res in
            guard let res else { return }
            self?.parseReceipt(res)
        }
    }
    
    private func parseReceipt(_ receipt: [String: Any]) {
        if let latestReceiptInfo = receipt["latest_receipt_info"] as? [[String: Any]] {
            for transaction in latestReceiptInfo {
                if let productId = transaction["product_id"] as? String,
                   let expiresDateStr = transaction["expires_date"] as? String,
                   let expiresDate = parseDate(expiresDateStr) {
                    let isActive = isSubscriptionActive(expiresDate: expiresDate)
                }
            }
        }
    }

    private func parseDate(_ dateStr: String) -> Date? {
        // For example, "2023-11-25 10:00:00 Etc/GMT"
        nil
    }
    
    private func isSubscriptionActive(expiresDate: Date) -> Bool {
        Date() < expiresDate
    }
    
    private func validateReceipt(receiptData: String, isSandbox: Bool = false, completion: @escaping ([String: Any]?) -> Void) {
        let urlString = isSandbox ? "https://sandbox.itunes.apple.com/verifyReceipt" : "https://buy.itunes.apple.com/verifyReceipt"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestData: [String: Any] = [
            "receipt-data": receiptData,
            "password": "<your-shared-secret>",
            "exclude-old-transactions": true
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestData, options: []) else { return }
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let receiptInfo = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                completion(nil)
                return
            }
            completion(receiptInfo)
        }
        task.resume()
    }
    
    private func getAppReceipt() -> Data? {
        if let appReceiptURL = Bundle.main.appStoreReceiptURL,
           let receiptData = try? Data(contentsOf: appReceiptURL) {
            return receiptData
        } else {
            refreshReceipt()
            return nil
        }
    }
    
    private func refreshReceipt() {
        let request = SKReceiptRefreshRequest()
        request.delegate = self
        request.start()
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
    
    func requestDidFinish(_ request: SKRequest) {}
}
