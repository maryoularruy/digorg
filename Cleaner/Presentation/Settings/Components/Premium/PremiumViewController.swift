//
//  PremiumViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.11.2024.
//

import StoreKit

protocol PremiumVCDelegate: AnyObject {
    func viewWasDismissed()
}

final class PremiumViewController: UIViewController {
    weak var delegate: PremiumVCDelegate?
    
    private lazy var rootView = PremiumView()
    
    private lazy var store = Store.shared
    private lazy var userDefaultsService = UserDefaultsService.shared

    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.viewWasDismissed()
    }
    
    private func updateUI() {
        guard let product = store.products.first else { return }
        let price = "\(product.displayPrice) / week"
        
        //
        if userDefaultsService.isSubscriptionActive {
            
        } else {
            Task.init {
                if await store.isTrialEligible() {
                    rootView.offerDescriptionView.setupTrialUI()
                    rootView.premiumOfferView.setupTrialUI(price: price)
                } else {
                    
                }
            }
        }
        //
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
//        Store.shared.restorePurchases()
    }
    
    func tapOnPrivacyPolicy() {
        
    }
    
    func tapOnTermsOfUse() {
        
    }
}

extension PremiumViewController: PremiumOfferViewDelegate {
    func tapOnOfferButton(with status: PurchaseStatus) {
        guard let product = store.products.first else { return }
        
        Task.init {
            do {
                try await store.purchase()
            } catch {
                
            }
        }
    }
}
