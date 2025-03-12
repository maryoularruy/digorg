//
//  PreviewView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.03.2025.
//

import UIKit
import AVFoundation

protocol PreviewViewDelegate: AnyObject {
    func tapOnStartSubscriptionButton()
    func tapOnRestore()
    func tapOnTermsOfUse()
    func tapOnClose()
}

final class PreviewView: UIView {
    weak var delegate: PreviewViewDelegate?
    
    private lazy var closeImageView: UIImageView = UIImageView(image: UIImage(systemName: "xmark"))
    
    lazy var pageController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    lazy var pageControl: UIPageControl = UIPageControl()
    
    private lazy var applicationNameLabel: Semibold24LabelStyle = {
        let label = Semibold24LabelStyle()
        label.bind(text: "Cleaner: Mastero & Prod")
        return label
    }()
    
    private lazy var priceLabel: Regular12LabelStyle = {
        let label = Regular12LabelStyle()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var startSubscriptionButton: ActionToolbarButtonStyle = {
        let button = ActionToolbarButtonStyle()
        button.layer.cornerRadius = 30
        button.bind(text: "Continue")
        return button
    }()
    
    private lazy var termsOfUseLabel: Regular13LabelStyle = {
        let label = Regular13LabelStyle()
        label.underlined(text: "Terms of Use")
        return label
    }()
    
    private lazy var restoreLabel: Regular13LabelStyle = {
        let label = Regular13LabelStyle()
        label.underlined(text: "Restore")
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
    
    func bind(price: String) {
        if price.isEmpty {
            priceLabel.bind(text: "Try 3 days for free, then $5.99 / week")
        } else {
            priceLabel.bind(text: "Try 3 days for free, then \(price)")
        }
    }
    
    func animateStartSubscriptionButton() {
        startSubscriptionButton.animate()
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
        closeImageView.tintColor = .pureWhite
        
        startSubscriptionButton.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnStartSubscriptionButton()
        }
        
        termsOfUseLabel.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnTermsOfUse()
        }
        
        restoreLabel.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnRestore()
        }
        
        closeImageView.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnClose()
        }
    }
    
    private func initConstraints() {
        addSubviews([pageController.view,
                     pageControl,
                     applicationNameLabel,
                     priceLabel,
                     startSubscriptionButton,
                     termsOfUseLabel,
                     restoreLabel])
        pageController.view.addSubviews([closeImageView])
        
        NSLayoutConstraint.activate([
            termsOfUseLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38),
            termsOfUseLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            
            restoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38),
            restoreLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            
            startSubscriptionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38),
            startSubscriptionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38),
            startSubscriptionButton.bottomAnchor.constraint(equalTo: termsOfUseLabel.topAnchor, constant: -15),
            startSubscriptionButton.heightAnchor.constraint(equalToConstant: 60),

            priceLabel.bottomAnchor.constraint(equalTo: startSubscriptionButton.topAnchor, constant: -22),
            priceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            applicationNameLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -11),
            applicationNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            pageController.view.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            pageController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageController.view.bottomAnchor.constraint(equalTo: applicationNameLabel.topAnchor, constant: -10),
            
            pageControl.bottomAnchor.constraint(equalTo: pageController.view.bottomAnchor, constant: -8),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            closeImageView.topAnchor.constraint(equalTo: pageController.view.topAnchor, constant: 24),
            closeImageView.leadingAnchor.constraint(equalTo: pageController.view.leadingAnchor, constant: 20),
            closeImageView.heightAnchor.constraint(equalToConstant: 20),
            closeImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
}
