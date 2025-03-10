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
}

final class PreviewView: UIView {
    weak var delegate: PreviewViewDelegate?
    
    lazy var pageController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    
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
    
    func animateStartSubscriptionButton() {
        startSubscriptionButton.animate()
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
        
        startSubscriptionButton.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnStartSubscriptionButton()
        }
        
        termsOfUseLabel.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnTermsOfUse()
        }
        
        restoreLabel.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnRestore()
        }
    }
    
    private func initConstraints() {
        addSubviews([pageController.view, startSubscriptionButton, termsOfUseLabel, restoreLabel])
        
        NSLayoutConstraint.activate([
            pageController.view.topAnchor.constraint(equalTo: topAnchor),
            pageController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageController.view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -150),
            
            termsOfUseLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38),
            termsOfUseLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            
            restoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38),
            restoreLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            
            startSubscriptionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38),
            startSubscriptionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38),
            startSubscriptionButton.bottomAnchor.constraint(equalTo: termsOfUseLabel.topAnchor, constant: -15),
            startSubscriptionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
