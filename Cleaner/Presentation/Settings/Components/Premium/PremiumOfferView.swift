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
        title.bind(text: "3 days for Free!")
        
        let commonPriceLabel = Semibold15LabelStyle()
        commonPriceLabel.setGreyText()
        commonPriceLabel.bind(text: price)
        
        let startTrialButton = ActionToolbarButtonStyle()
        startTrialButton.layer.cornerRadius = 30
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
            
            title.topAnchor.constraint(equalTo: topAnchor, constant: 22),
            title.bottomAnchor.constraint(equalTo: commonPriceLabel.topAnchor, constant: -11),
            title.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setupStartSubscription(price: String, expirationDate: Date? = nil) {
        let priceLabel = Semibold24LabelStyle()
        priceLabel.bind(text: price)
        
        let startSubscriptionButton = ActionToolbarButtonStyle()
        startSubscriptionButton.layer.cornerRadius = 30
        startSubscriptionButton.bind(text: "Continue")
        startSubscriptionButton.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnOfferButton(with: .purchaseWeeklyRenewableSubscription)
        }
        
        let subscriptionConditionsLabel = Regular12LabelStyle()
        subscriptionConditionsLabel.numberOfLines = 1
        subscriptionConditionsLabel.bind(text: "Auto-renewable. Cancel Anytime")
        
        addSubviews([priceLabel, startSubscriptionButton, subscriptionConditionsLabel])
        
        NSLayoutConstraint.activate([
            subscriptionConditionsLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            subscriptionConditionsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            startSubscriptionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38),
            startSubscriptionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38),
            startSubscriptionButton.bottomAnchor.constraint(equalTo: subscriptionConditionsLabel.topAnchor, constant: -15),
            startSubscriptionButton.heightAnchor.constraint(equalToConstant: 60),
            
            priceLabel.bottomAnchor.constraint(equalTo: startSubscriptionButton.topAnchor, constant: -20),
            priceLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
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
}
