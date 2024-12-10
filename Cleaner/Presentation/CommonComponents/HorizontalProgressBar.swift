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
    
    var currentProgress: CGFloat = 0.0
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
    
    func addProgress(_ progress: CGFloat) {
        currentProgress += progress
        updateProgress(to: currentProgress)
    }
    
    func updateProgress(to progress: CGFloat) {
        currentProgress = progress
        let clampedProgress = max(0.0, min(progress, 1.0))
        let maxWidth = backgroundView.frame.width
        let newWidth = maxWidth * clampedProgress
        
        DispatchQueue.main.async { [weak self] in
            self?.progressWidthConstraint.constant = newWidth
            
            UIView.animate(withDuration: 0.2) {
                self?.layoutIfNeeded()
            }
        }
    }
    
    private func setupView() {
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
            
            foregroundView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            foregroundView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            foregroundView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            progressWidthConstraint
        ])
    }
}
