//
//  BuyPremiumView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.11.2024.
//

import UIKit

protocol BuyPremiumViewDelegate: AnyObject {
    func tapOnStartTrial()
}

final class BuyPremiumView: UIView {
    static var height: CGFloat = 122.0
    weak var delegate: BuyPremiumViewDelegate?
    
    private lazy var contentView: UIView = UIView()
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.bind(text: "Cleaner Unlimited\nFeatures")
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var startTrialButton: Medium12ButtonStyle = {
        let button = Medium12ButtonStyle()
        button.bind(text: "Start Trial")
        button.layer.cornerRadius = 16
        return button
    }()
    
    private lazy var background: UIImageView = {
        let imageView = UIImageView(image: .buyPremiumBackground)
        imageView.contentMode = .scaleAspectFill
        return imageView
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
        contentView.backgroundColor = .paleGrey
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        addShadows()
        
        addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnStartTrial()
        }
        
        startTrialButton.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnStartTrial()
        }
    }
    
    private func initConstraints() {
        addSubviews([contentView])
        contentView.addSubviews([label, startTrialButton, background])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            
            startTrialButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
            startTrialButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            startTrialButton.heightAnchor.constraint(equalToConstant: 32),
            
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: label.trailingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
