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
        Task.detached { await self.getProducts() }
    }
    
    deinit {
        print("deinit")
    }
    
    private func getProducts() async {
        do {
            products = try await store.getProducts()
        } catch(let error) {
            showAlert(title: "Unknowed error", subtitle: error.localizedDescription)
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
            guard let weekly = (products.first { $0.id == "premium.weekly" }) else { return }
            Task {
                do {
                    let result = try await store.purchase(weekly)
                    switch result {
                    case .success(_): break
                    case .failure(let error):
                        showAlert(error: error)
                    }
                } catch(let error) {
                    showAlert(title: "Unknown error", subtitle: error.localizedDescription)
                }
            }
            
        case .connectWeeklyRenewableSubscription: break
            
        case .cancelSubscription: break
            
        }
    }
}
