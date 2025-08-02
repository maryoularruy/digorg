//
//  OfferDescriptionView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 22.11.2024.
//

import UIKit

final class OfferDescriptionView: UIView {
    func setupStartSubscriptionUI() {
        let label = Regular15LabelStyle()
        label.bind(text: "Unlock advanced organization tools")
        label.setGreyTextColor()
        
        addSubviews([label])
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupTrialUI(price: String, expirationDate: Date) {
        let currentStatusLabel = Semibold24LabelStyle()
        currentStatusLabel.bind(text: "3 days Trial")
        
        let renewsDateLabel = Regular15LabelStyle()
        renewsDateLabel.bind(text: "Renews \(expirationDate.toDayAndMonth()), \(price)")
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
    
    func setupSubscriptionUI(price: String, expirationDate: Date) {
        let currentStatusLabel = Semibold24LabelStyle()
        currentStatusLabel.bind(text: price)
        
        let renewsDateLabel = Regular15LabelStyle()
        renewsDateLabel.bind(text: "Renews \(expirationDate.toDayAndMonth())")
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
