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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupPurchaseStatus()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    
    deinit {
        print("deinit")
    }
    
    private func setupPurchaseStatus() {
        guard let product = ServiceFactory.shared.store.purchasedSubscriptions.first(where: { $0.id == WEEKLY_PREMIUM_ID }) else { return }
        
        let currentUserPurchase: CurrentUserPurchase = if ServiceFactory.shared.store.purchasedSubscriptions.isEmpty {
            .none
        } else {
            if product.subscription?.introductoryOffer == nil {
                .weeklyRenewableSubscription
            } else {
                .trial
            }
        }
        
        let purchaseStatus: PurchaseStatus = if ServiceFactory.shared.store.purchasedSubscriptions.isEmpty {
            .purchaseThreeDaysTrial
        } else {
            if product.subscription?.introductoryOffer == nil {
                .cancelSubscription
            } else {
                .purchaseWeeklyRenewableSubscription
            }
        }
        rootView.offerDescriptionView.configureUI(for: purchaseStatus)
        rootView.premiumOfferView.configureUI(for: purchaseStatus)
    }
}

extension PremiumViewController: ViewControllerProtocol {
    func setupUI() {
        rootView.delegate = self
        rootView.premiumOfferView.delegate = self
    }
    
    func addGestureRecognizers() {
        
    }
}

extension PremiumViewController: PremiumViewDelegate {
    func tapOnCancel() {
        dismiss(animated: true)
    }
    
    func tapOnRestore() {
        
    }
    
    func tapOnPrivacyPolicy() {
        
    }
    
    func tapOnTermsOfUse() {
        
    }
}

extension PremiumViewController: PremiumOfferViewDelegate {
    func tapOnOfferButton(with status: PurchaseStatus) {
        switch status {
        case .purchaseThreeDaysTrial:
            guard let weekly = (ServiceFactory.shared.store.subscriptions.first { $0.id == WEEKLY_PREMIUM_ID }) else { return }
            Task {
                do {
                    let result = try await ServiceFactory.shared.store.purchase(weekly)
                    switch result {
                    case .success(_): viewWillLayoutSubviews()
                    case .failure(let error):
                        showAlert(error: error)
                    }
                } catch(let error) {
                    showAlert(title: "Unknown error", subtitle: error.localizedDescription)
                }
            }
            
        case .purchaseWeeklyRenewableSubscription: break
            
        case .cancelSubscription: break
            
        }
    }
}
