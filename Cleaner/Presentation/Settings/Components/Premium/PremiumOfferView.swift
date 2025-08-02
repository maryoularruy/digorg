//
//  PremiumOfferView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.11.2024.
//

import UIKit

protocol PremiumOfferViewDelegate: AnyObject {
    func tapOnOfferButton(with status: PurchaseStatus)
}

final class PremiumOfferView: UIView {
    weak var delegate: PremiumOfferViewDelegate?
    
    func setupTrialUI(price: String) {
        let title = Semibold24LabelStyle()
        title.bind(text: "3-day free trial")
        
        let commonPriceLabel = Semibold15LabelStyle()
        commonPriceLabel.setGreyText()
        commonPriceLabel.bind(text: price)
        
        let startTrialButton = ActionToolbarButtonStyle()
        startTrialButton.layer.cornerRadius = 30
        startTrialButton.bind(text: "Start free trial")
        startTrialButton.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnOfferButton(with: .purchaseThreeDaysTrial)
        }
        
        let subscriptionConditionsLabel = Regular12LabelStyle()
        subscriptionConditionsLabel.numberOfLines = 1
        subscriptionConditionsLabel.bind(text: "Subscription automatically renews unless cancelled")
        
        addSubviews([title, commonPriceLabel, startTrialButton, subscriptionConditionsLabel])
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            commonPriceLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            commonPriceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            startTrialButton.topAnchor.constraint(equalTo: commonPriceLabel.bottomAnchor, constant: 16),
            startTrialButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            startTrialButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            startTrialButton.heightAnchor.constraint(equalToConstant: 60),
            
            subscriptionConditionsLabel.topAnchor.constraint(equalTo: startTrialButton.bottomAnchor, constant: 8),
            subscriptionConditionsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subscriptionConditionsLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupStartSubscription(price: String, expirationDate: Date? = nil) {
        let priceLabel = Semibold24LabelStyle()
        priceLabel.bind(text: price)
        
        let startSubscriptionButton = ActionToolbarButtonStyle()
        startSubscriptionButton.layer.cornerRadius = 30
        startSubscriptionButton.bind(text: "Subscribe")
        startSubscriptionButton.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnOfferButton(with: .purchaseWeeklyRenewableSubscription)
        }
        
        let subscriptionConditionsLabel = Regular12LabelStyle()
        subscriptionConditionsLabel.numberOfLines = 1
        subscriptionConditionsLabel.bind(text: "Subscription automatically renews unless cancelled")
        
        addSubviews([priceLabel, startSubscriptionButton, subscriptionConditionsLabel])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: topAnchor),
            priceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            startSubscriptionButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            startSubscriptionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            startSubscriptionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            startSubscriptionButton.heightAnchor.constraint(equalToConstant: 60),
            
            subscriptionConditionsLabel.topAnchor.constraint(equalTo: startSubscriptionButton.bottomAnchor, constant: 8),
            subscriptionConditionsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subscriptionConditionsLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        if let expirationDate {
            let expirationDateLabel = Regular15LabelStyle()
            expirationDateLabel.setGreyTextColor()
            expirationDateLabel.bind(text: "Your current Plan expires \(expirationDate.toDayAndMonth())")
            
            addSubviews([expirationDateLabel])
            
            NSLayoutConstraint.activate([
                expirationDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
                expirationDateLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -33),
                expirationDateLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 53)
            ])
        }
    }
    
    func setupCancelSubscriptionUI(expirationDate: Date) {
        let cancelSubscriptionButton = ActionToolbarButtonStyle()
        cancelSubscriptionButton.layer.cornerRadius = 25
        cancelSubscriptionButton.setupCancelSubscriptionStyle()
        cancelSubscriptionButton.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnOfferButton(with: .cancelSubscription)
        }
        
        let subscriptionConditionsLabel = Regular12LabelStyle()
        subscriptionConditionsLabel.numberOfLines = 2
        subscriptionConditionsLabel.bind(text: "If you cancel now, you can still access\n your subscription untill \(expirationDate.toFullDateWithDots())")
        
        addSubviews([cancelSubscriptionButton, subscriptionConditionsLabel])
        
        NSLayoutConstraint.activate([
            subscriptionConditionsLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            subscriptionConditionsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            cancelSubscriptionButton.topAnchor.constraint(equalTo: topAnchor, constant: 47),
            cancelSubscriptionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38),
            cancelSubscriptionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38),
            cancelSubscriptionButton.bottomAnchor.constraint(equalTo: subscriptionConditionsLabel.topAnchor, constant: -15),
            cancelSubscriptionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func animateButton() {
        guard let button = subviews.first(where: { $0 is ActionToolbarButtonStyle }) as? ActionToolbarButtonStyle else { return }
        button.animate()
    }
}
