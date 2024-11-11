//
//  OptimizeBatteryChargingView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.11.2024.
//

import UIKit

final class OptimizeBatteryChargingView: UIView {
    lazy var arrowBack: UIView = arrowBackButton
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        initConstraints()
    }
    
    private func setupView() {
        backgroundColor = .white
    }
    
    private func initConstraints() {
        addSubviews([arrowBackButton])
        
        NSLayoutConstraint.activate([
            arrowBackButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
            arrowBackButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            arrowBackButton.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBackButton.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width)
        ])
    }
}
