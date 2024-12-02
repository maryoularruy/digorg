//
//  HorizontalProgressBar.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.11.2024.
//

import UIKit

final class HorizontalProgressBar: UIView {
    private let backgroundView = UIView()
    private let foregroundView = UIView()
    
    private var progressWidthConstraint: NSLayoutConstraint!
    
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
    
    func updateProgress(to progress: CGFloat) {
        let clampedProgress = max(0.0, min(progress, 1.0))
        let maxWidth = backgroundView.frame.width
        let newWidth = maxWidth * clampedProgress
        
        progressWidthConstraint.constant = newWidth
        
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    private func setupView() {
        backgroundColor = .red
        
        backgroundView.backgroundColor = .lightBlue
        backgroundView.layer.cornerRadius = 7
        backgroundView.clipsToBounds = true
        
        progressWidthConstraint = foregroundView.widthAnchor.constraint(equalToConstant: 0)
        progressWidthConstraint.isActive = true
        foregroundView.backgroundColor = .blue
        foregroundView.layer.cornerRadius = 7
        foregroundView.clipsToBounds = true
    }
    
    private func initConstraints() {
        addSubviews([backgroundView])
        backgroundView.addSubviews([foregroundView])
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 12),
            backgroundView.widthAnchor.constraint(equalTo: widthAnchor),
            
            foregroundView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            foregroundView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            foregroundView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            progressWidthConstraint
        ])
    }
}
