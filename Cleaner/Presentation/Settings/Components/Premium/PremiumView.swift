//
//  PremiumView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.11.2024.
//

import UIKit

protocol PremiumViewDelegate: AnyObject {
    func tapOnCancel()
    func tapOnRestore()
}

final class PremiumView: UIView {
    weak var delegate: PremiumViewDelegate?
    
    private lazy var contentView = UIView()

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .premiumVCBackground
        return imageView
    }()
    
    private lazy var restoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Restore"
        label.textColor = .greyText
        label.font = .medium13
        return label
    }()
    
    private lazy var cancelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .cancelPremiumVC
        imageView.contentMode = .center
        imageView.clipsToBounds = false
        return imageView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .premiumVCIcon
        return imageView
    }()
    
    private lazy var premiumLabel: Semibold24LabelStyle = {
        let label = Semibold24LabelStyle()
        label.bind(text: "Premium")
        return label
    }()
    
    private lazy var subtitleLabel: Regular15LabelStyle = {
        let label = Regular15LabelStyle()
        label.bind(text: "Get full access to all features")
        label.setGreyTextColor()
        return label
    }()
    
    private lazy var premiumFeaturesView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderWidth = 3
        return view
    }()
    
    private lazy var premiumFeaturesStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.backgroundColor = .green
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .equalSpacing
        
        ["Removing duplicates", "Secret Album", "Secret Contacts", "No Ads"].forEach { text in
            let checkmarkImageView = UIImageView(image: .checkmark)
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
            let label = Semibold15LabelStyle()
            label.bind(text: text)
            
            let view = UIView()
            view.addSubviews([checkmarkImageView, label])
            
            NSLayoutConstraint.activate([
                checkmarkImageView.topAnchor.constraint(equalTo: view.topAnchor),
                checkmarkImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                checkmarkImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                label.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: 10),
                label.centerYAnchor.constraint(equalTo: checkmarkImageView.centerYAnchor)
            ])

            stackView.addArrangedSubview(view)
        }
        
        return stackView
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
        
        restoreLabel.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnRestore()
        }
        
        cancelImageView.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnCancel()
        }
    }
    
    private func initConstraints() {
        addSubviews([backgroundImageView,
                     restoreLabel,
                     cancelImageView,
                     iconImageView,
                     premiumLabel,
                     subtitleLabel,
                     premiumFeaturesView])
        
        premiumFeaturesView.addSubviews([premiumFeaturesStackView])
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            restoreLabel.topAnchor.constraint(equalTo: topAnchor, constant: 23),
            restoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            cancelImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21),
            cancelImageView.centerYAnchor.constraint(equalTo: restoreLabel.centerYAnchor),
            cancelImageView.heightAnchor.constraint(equalToConstant: 25),
            cancelImageView.widthAnchor.constraint(equalToConstant: 25),
            
            iconImageView.topAnchor.constraint(equalTo: restoreLabel.bottomAnchor, constant: 1),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 191),
            iconImageView.widthAnchor.constraint(equalToConstant: 175),
            
            premiumLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 21),
            premiumLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: premiumLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            premiumFeaturesView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            premiumFeaturesView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38),
            premiumFeaturesView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38),
            
            premiumFeaturesStackView.topAnchor.constraint(equalTo: premiumFeaturesView.topAnchor, constant: 25),
            premiumFeaturesStackView.leadingAnchor.constraint(equalTo: premiumFeaturesView.leadingAnchor, constant: 24),
            premiumFeaturesStackView.trailingAnchor.constraint(equalTo: premiumFeaturesView.trailingAnchor, constant: -24),
            premiumFeaturesStackView.bottomAnchor.constraint(equalTo: premiumFeaturesView.bottomAnchor, constant: -25)
        ])
    }
}
