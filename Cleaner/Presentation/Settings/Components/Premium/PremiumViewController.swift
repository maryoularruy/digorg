//
//  PremiumViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.11.2024.
//

import UIKit

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
}

extension PremiumViewController: PremiumOfferViewDelegate {
    func tapOnOfferButton(with status: SubscriptionSuggestion) {
        switch status {
        case .connectThreeDaysTrial: break
            
        case .connectWeeklyRenewableSubscription: break
            
        case .cancelSubscription: break
            
        }
    }
}
