//
//  PreviewView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.03.2025.
//

import UIKit
import AVFoundation

final class PreviewView: UIView {
    lazy var pageController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    
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
        
    }
    
    private func initConstraints() {
        addSubviews([pageController.view])
        
        NSLayoutConstraint.activate([
            pageController.view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            pageController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageController.view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -150)
        ])
    }
}
