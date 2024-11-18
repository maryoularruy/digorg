//
//  PremiumOfferView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.11.2024.
//

import UIKit

enum SubscriptionSuggestion {
    case connectThreeDaysTrial, connectWeeklyRenewableSubscription, cancelSubscription
}

protocol PremiumOfferViewDelegate: AnyObject {
    func tapOnOfferButton(with status: SubscriptionSuggestion)
}

final class PremiumOfferView: UIView {
    weak var delegate: PremiumOfferViewDelegate?
    private var subscriptionStatus: SubscriptionSuggestion?
    
    func configureUI(for status: SubscriptionSuggestion) {
        self.subscriptionStatus = status
        subviews.forEach { $0.removeFromSuperview() }
        
        switch status {
        case .connectThreeDaysTrial: setupTrialUI()
        case .connectWeeklyRenewableSubscription: setupSubscriptionUI()
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
            self?.delegate?.tapOnOfferButton(with: .connectThreeDaysTrial)
        }
        
        let subscriptionConditionsLabel = Regular12LabelStyle()
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
        
    }
    
    private func setupCancelSubscriptionUI() {
        
    }
}
