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
        
        if ServiceFactory.shared.store.purchasedSubscriptions.isEmpty {
            
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
    }
    
    deinit {
        print("deinit")
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
            guard let weekly = (ServiceFactory.shared.store.subscriptions.first { $0.id == "premium.weekly" }) else { return }
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
            
        case .connectWeeklyRenewableSubscription: break
            
        case .cancelSubscription: break
            
        }
    }
}
