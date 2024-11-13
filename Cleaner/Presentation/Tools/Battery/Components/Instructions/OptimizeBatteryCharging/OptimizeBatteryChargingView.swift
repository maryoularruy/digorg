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
        addSubviews([arrowBackButton,
                     label,
                     pageController.view,
                     pageControl,
                     actionButton
                    ])
        
        NSLayoutConstraint.activate([
            arrowBackButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
            arrowBackButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            arrowBackButton.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBackButton.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
            
            label.topAnchor.constraint(equalTo: arrowBackButton.bottomAnchor, constant: 16),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),

            pageController.view.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            pageController.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            pageController.view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            pageController.view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -110),
            
            pageControl.bottomAnchor.constraint(equalTo: pageController.view.bottomAnchor, constant: 0),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32)
        ])
    }
}
