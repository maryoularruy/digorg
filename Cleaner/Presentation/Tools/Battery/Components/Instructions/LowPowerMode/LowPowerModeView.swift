//
//  LowPowerModeView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 13.11.2024.
//

import UIKit

final class LowPowerModeView: UIView {
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold24LabelStyle()
        label.bind(text: "Low Power Mode")
        return label
    }()
    
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
        addSubviews([arrowBack, label])
        
        NSLayoutConstraint.activate([
            arrowBack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
            arrowBack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            arrowBack.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBack.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
            
            label.topAnchor.constraint(equalTo: arrowBack.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
}
