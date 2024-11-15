//
//  OptimizeBatteryChargingView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.11.2024.
//

import UIKit

final class OptimizeBatteryChargingView: UIView {
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.bind(text: "Optimize Battery Charging")
        return label
    }()
    
    lazy var pageController: UIPageViewController = UIPageViewController(transitionStyle: .scroll,
                                                                         navigationOrientation: .horizontal,
                                                                         options: .none)
    
    lazy var pageControl: UIPageControl = UIPageControl()
    
    lazy var actionButton = ActionToolbarButtonStyle()
    
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
        addSubviews([arrowBack,
                     label,
                     pageController.view,
                     pageControl,
                     actionButton
                    ])
        
        NSLayoutConstraint.activate([
            arrowBack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 2),
            arrowBack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            arrowBack.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBack.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
            
            label.topAnchor.constraint(equalTo: arrowBack.bottomAnchor, constant: 22),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            
            pageControl.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -30),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            pageController.view.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            pageController.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            pageController.view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            pageController.view.bottomAnchor.constraint(equalTo: pageControl.topAnchor)
        ])
    }
}
