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
        cleanSubviews()
        
        if userDefaultsService.isSubscriptionActive {
            Task.init {
                if await store.isAutoRenew() {
                    guard let expirationDate = getExpirationDate() else { return }
                    setupCancelSubscriptionUI(expirationDate: expirationDate)
                } else {
                    setupStartSubscriptionUI(expirationDate: getExpirationDate())
                }
            }
            
        } else {
            Task.init {
                if await store.isTrialEligible() {
                    setupStartTrialUI()
                } else {
                    setupStartSubscriptionUI()
                }
            }
        }
    }
    
    private func setupStartTrialUI() {
        rootView.offerDescriptionView.setupStartSubscriptionUI()
        rootView.premiumOfferView.setupTrialUI(price: getSubscriptionPrice())
    }
    
    private func setupStartSubscriptionUI(expirationDate: Date? = nil) {
        rootView.offerDescriptionView.setupStartSubscriptionUI()
        rootView.premiumOfferView.setupStartSubscription(price: getSubscriptionPrice(), expirationDate: expirationDate)
    }
    
    private func setupCancelSubscriptionUI(expirationDate: Date) {
        Task.init {
            if await store.isTrialNow() {
                rootView.offerDescriptionView.setupTrialUI(price: getSubscriptionPrice(), expirationDate: expirationDate)
            } else {
                rootView.offerDescriptionView.setupSubscriptionUI(price: getSubscriptionPrice(), expirationDate: expirationDate)
            }
        }
        
        rootView.premiumOfferView.setupCancelSubscriptionUI(expirationDate: expirationDate)
    }
    
    private func cleanSubviews() {
        rootView.offerDescriptionView.subviews.forEach { $0.removeFromSuperview() }
        rootView.premiumOfferView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func getSubscriptionPrice() -> String {
        guard let product = store.products.first else { return "" }
        return "\(product.displayPrice) / week"
    }
    
    private func getExpirationDate() -> Date? {
        userDefaultsService.get(Date.self, key: .subscriptionExpirationDate)
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
        do {
            try Store.shared.restore() { [weak self] result in
                DispatchQueue.main.async {
                    if result {
                        self?.showAlert(title: "Success", subtitle: "Your subscriptions have been restored")
                    } else {
                        self?.showAlert(title: "Error", subtitle: "Could not restore purchases")
                    }
                }
            }
        } catch(let error) {
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(error: error)
            }
        }
    }
    
    func tapOnPrivacyPolicy() {
        
    }
    
    func tapOnTermsOfUse() {
        
    }
}

extension PremiumViewController: PremiumOfferViewDelegate {
    func tapOnOfferButton(with status: PurchaseStatus) {
        Task.init {
            do {
                try await store.purchase()
                updateUI()
            } catch(let error) {
                showAlert(error: error)
            }
        }
    }
}
