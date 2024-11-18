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
                     cancelImageView])
        
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
            cancelImageView.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
}
