//
//  Store.swift
//  Cleaner
//
//  Created by Elena Sedunova on 19.11.2024.
//

import StoreKit

final class Store {
    static var shared = Store()
    private let productIds = ["pro.weekly"]
//    var products: [Product] = []
    
    func getProducts() async throws -> [Product] {
        try await Product.products(for: productIds)
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()

        switch result {
        case let .success(.verified(transaction)):
            // Successful purhcase
            await transaction.finish()
        case let .success(.unverified(_, error)):
            // Successful purchase but transaction/receipt can't be verified
            // Could be a jailbroken phone
            break
        case .pending:
            // Transaction waiting on SCA (Strong Customer Authentication) or
            // approval from Ask to Buy
            break
        case .userCancelled:
            // ^^^
            break
        @unknown default:
            break
        }
    }
//
//    private func loadProducts() async throws {
//        self.products = try await Product.products(for: productIds)
//    }
}
