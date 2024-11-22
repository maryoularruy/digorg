//
//  UserService.swift
//  Cleaner
//
//  Created by Elena Sedunova on 22.11.2024.
//

import Foundation

enum CurrentUserPurchase {
    case trial, weeklyRenewableSubscription, none
}

final class UserService {
    private(set) var currentPurchaseStatus: CurrentUserPurchase {
        get {
            .trial
        }
        set {
            
        }
    }
    
//    func updateCurrentPurchaseStatus
    
    private func getCurrentPurchaseStatus() -> CurrentUserPurchase {
        .trial
    }
}
