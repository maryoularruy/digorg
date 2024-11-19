//
//  PremiumViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.11.2024.
//

import StoreKit

final class PremiumViewController: UIViewController {
    private lazy var rootView = PremiumView()
    private lazy var store = Store.shared
    private lazy var products: [Product] = []
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        Task { await getProducts() }
    }
    
    deinit {
        print("deinit")
    }
    
    private func getProducts() async {
        do {
            products = try await store.getProducts()
        } catch {
            print("error")
        }
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
    func tapOnOfferButton(with status: SubscriptionSuggestion) {
        switch status {
        case .connectThreeDaysTrial:
            guard let weekly = (products.first { $0.id == "pro.weekly" }) else { return }
            Task {
                do {
                    try await store.purchase(weekly)
                } catch {
                    
                }
            }
            
        case .connectWeeklyRenewableSubscription: break
            
        case .cancelSubscription: break
            
        }
    }
}
