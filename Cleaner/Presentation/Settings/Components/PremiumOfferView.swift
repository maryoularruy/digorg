//
//  PremiumOfferView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.11.2024.
//

import UIKit

enum PurchaseStatus {
    case purchaseThreeDaysTrial, purchaseWeeklyRenewableSubscription, cancelSubscription
}

protocol PremiumOfferViewDelegate: AnyObject {
    func tapOnOfferButton(with status: PurchaseStatus)
}

final class PremiumOfferView: UIView {
    weak var delegate: PremiumOfferViewDelegate?
    private var subscriptionStatus: PurchaseStatus?
    
    func configureUI(for status: PurchaseStatus) {
        self.subscriptionStatus = status
        subviews.forEach { $0.removeFromSuperview() }
        
        switch status {
        case .purchaseThreeDaysTrial: setupTrialUI()
        case .purchaseWeeklyRenewableSubscription: setupSubscriptionUI()
        case .cancelSubscription: setupCancelSubscriptionUI()
        }
    }
    
    private func setupTrialUI() {
        let title = Semibold24LabelStyle()
        title.bind(text: "3 days for Free!")
        
        let commonPriceLabel = Semibold15LabelStyle()
        commonPriceLabel.setGreyText()
        commonPriceLabel.bind(text: "$5,99 / week")
        
        let startTrialButton = ActionToolbarButtonStyle()
        startTrialButton.bind(text: "Start 3 days trial")
        startTrialButton.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnOfferButton(with: .purchaseThreeDaysTrial)
        }
        
        let subscriptionConditionsLabel = Regular12LabelStyle()
        subscriptionConditionsLabel.numberOfLines = 1
        subscriptionConditionsLabel.bind(text: "Auto-renewable. Cancel Anytime")
        
        addSubviews([title, commonPriceLabel, startTrialButton, subscriptionConditionsLabel])
        
        NSLayoutConstraint.activate([
            subscriptionConditionsLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            subscriptionConditionsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            startTrialButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38),
            startTrialButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38),
            startTrialButton.bottomAnchor.constraint(equalTo: subscriptionConditionsLabel.topAnchor, constant: -15),
            startTrialButton.heightAnchor.constraint(equalToConstant: 60),
            
            commonPriceLabel.bottomAnchor.constraint(equalTo: startTrialButton.topAnchor, constant: -22),
            commonPriceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            title.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            title.bottomAnchor.constraint(equalTo: commonPriceLabel.topAnchor, constant: -11),
            title.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupSubscriptionUI() {
        let cancelSubscriptionButton = ActionToolbarButtonStyle()
        cancelSubscriptionButton.setupCancelSubscriptionStyle()
        cancelSubscriptionButton.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnOfferButton(with: .cancelSubscription)
        }
        
        let subscriptionConditionsLabel = Regular12LabelStyle()
        subscriptionConditionsLabel.numberOfLines = 2
        subscriptionConditionsLabel.bind(text: "If you cancel now, you can still access\n your subscription untill 08.08.24")
        
        addSubviews([cancelSubscriptionButton, subscriptionConditionsLabel])
        
        NSLayoutConstraint.activate([
            subscriptionConditionsLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            subscriptionConditionsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            cancelSubscriptionButton.topAnchor.constraint(equalTo: topAnchor, constant: 59),
            cancelSubscriptionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38),
            cancelSubscriptionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38),
            cancelSubscriptionButton.bottomAnchor.constraint(equalTo: subscriptionConditionsLabel.topAnchor, constant: -15),
            cancelSubscriptionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupCancelSubscriptionUI() {
        
    }
}
