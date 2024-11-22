//
//  PurchaseStatus.swift
//  Cleaner
//
//  Created by Elena Sedunova on 22.11.2024.
//

import Foundation

enum PurchaseStatus {
    case purchaseThreeDaysTrial, purchaseWeeklyRenewableSubscription, cancelSubscription
}

enum CurrentUserPurchase {
    case trial, weeklyRenewableSubscription, none
}
