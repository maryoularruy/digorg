//
//  InstructionView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 13.11.2024.
//

import UIKit

final class InstructionView: UIView {
    let title: String?
    let instructionDescription: String
    
    private lazy var mainLabel: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var descriptionLabel: Regular15LabelStyle = {
        let label = Regular15LabelStyle()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    init(title: String? = nil, description: String) {
        self.title = title
        self.instructionDescription = description
        super.init(frame: .zero)
        setupView()
        initConstraints()
        bind(title: title, description: description)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(title: String?, description: String) {
        if let title {
            mainLabel.bind(text: title)
        }
        descriptionLabel.bind(text: description)
    }
    
    private func setupView() {
        clipsToBounds = false
        backgroundColor = .paleGrey
        addShadows()
        layer.cornerRadius = 20
    }
    
    private func initConstraints() {
        addSubviews([mainLabel, descriptionLabel])
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
