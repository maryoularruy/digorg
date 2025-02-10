//
//  TipView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 23.01.2025.
//

import UIKit

final class TipView: UIView {
    private lazy var tipImageView: UIImageView = UIImageView(image: .tip)
    
    private lazy var tipLabel: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.bind(text: "Tips")
        return label
    }()
    
    private lazy var tipDescriptionLabel: Regular15LabelStyle = {
        let label = Regular15LabelStyle()
        label.bind(text: "Don’t let other know your answer")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        initContraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        initContraints()
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
        layer.cornerRadius = 20
        addShadows()
    }
    
    private func initContraints() {
        addSubviews([tipImageView, tipLabel, tipDescriptionLabel])
        
        NSLayoutConstraint.activate([
            tipImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            tipImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tipImageView.heightAnchor.constraint(equalToConstant: 24),
            tipImageView.widthAnchor.constraint(equalToConstant: 24),
            
            tipLabel.leadingAnchor.constraint(equalTo: tipImageView.trailingAnchor, constant: 8),
            tipLabel.centerYAnchor.constraint(equalTo: tipImageView.centerYAnchor),
            
            tipDescriptionLabel.topAnchor.constraint(equalTo: tipImageView.bottomAnchor, constant: 4),
            tipDescriptionLabel.leadingAnchor.constraint(equalTo: tipLabel.leadingAnchor),
            tipDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
