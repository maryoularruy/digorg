//
//  ServiceFactory.swift
//  Cleaner
//
//  Created by Elena Sedunova on 22.11.2024.
//

import StoreKit

final class ServiceFactory {
    static let shared = ServiceFactory()
    
    let store: Store
    
    private init() {
        store = Store()
    }
}
