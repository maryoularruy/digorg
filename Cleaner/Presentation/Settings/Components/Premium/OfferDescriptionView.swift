//
//  OfferDescriptionView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 22.11.2024.
//

import UIKit

final class OfferDescriptionView: UIView {
    func setupTrialUI() {
        let label = Regular15LabelStyle()
        label.bind(text: "Get full access to all features")
        label.setGreyTextColor()
        
        addSubviews([label])
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func setupSubscriptionUI() {
        let currentStatusLabel = Semibold24LabelStyle()
        currentStatusLabel.bind(text: "3 days Trial")
        
        let renewsDateLabel = Regular15LabelStyle()
        renewsDateLabel.bind(text: "Renews 14 July, $5.99/week")
        renewsDateLabel.setGreyTextColor()
        
        addSubviews([currentStatusLabel, renewsDateLabel])
        
        NSLayoutConstraint.activate([
            currentStatusLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            currentStatusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            renewsDateLabel.topAnchor.constraint(equalTo: currentStatusLabel.bottomAnchor, constant: 11),
            renewsDateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            renewsDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupCancelSubscriptionUI() {
        let currentStatusLabel = Semibold24LabelStyle()
        currentStatusLabel.bind(text: "$5.99 / week")
        
        let renewsDateLabel = Regular15LabelStyle()
        renewsDateLabel.bind(text: "Renews 14 July")
        renewsDateLabel.setGreyTextColor()
        
        addSubviews([currentStatusLabel, renewsDateLabel])
        
        NSLayoutConstraint.activate([
            currentStatusLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            currentStatusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            renewsDateLabel.topAnchor.constraint(equalTo: currentStatusLabel.bottomAnchor, constant: 11),
            renewsDateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            renewsDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
