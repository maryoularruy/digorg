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
    
    lazy var pageController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
        vc.view.backgroundColor = .acidGreen
        return vc
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
        addSubviews([arrowBackButton,
                     label,
                     pageController.view
                    ])
        
        NSLayoutConstraint.activate([
            arrowBackButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
            arrowBackButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            arrowBackButton.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBackButton.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
            
            label.topAnchor.constraint(equalTo: arrowBackButton.bottomAnchor, constant: 16),
            label.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),

            pageController.view.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            pageController.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            pageController.view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            pageController.view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -110)
        ])
    }
}
