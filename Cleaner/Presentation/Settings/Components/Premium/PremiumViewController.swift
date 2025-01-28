//
//  PremiumViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.11.2024.
//

import StoreKit

final class PremiumViewController: UIViewController {
    private lazy var rootView = PremiumView()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension PremiumViewController: ViewControllerProtocol {
    func setupUI() {
        rootView.delegate = self
        rootView.premiumOfferView.delegate = self
    }
    
    func addGestureRecognizers() {}
}

extension PremiumViewController: PremiumViewDelegate {
    func tapOnCancel() {
        dismiss(animated: true)
    }
    
    func tapOnRestore() {
        Store.shared.restorePurchases()
    }
    
    func tapOnPrivacyPolicy() {
        
    }
    
    func tapOnTermsOfUse() {
        
    }
}

extension PremiumViewController: PremiumOfferViewDelegate {
    func tapOnOfferButton(with status: PurchaseStatus) {
        guard let subscription = Store.shared.subscriptions.first else { return }
        
        switch status {
        case .purchaseThreeDaysTrial:
            Store.shared.purchase(subscription)
            
        case .purchaseWeeklyRenewableSubscription:
            Store.shared.purchase(subscription)
            
        case .cancelSubscription:
            Store.shared.purchase(subscription)
        }
    }
}
