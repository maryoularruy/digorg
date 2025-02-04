//
//  ScanningStoreView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 04.02.2025.
//

import UIKit

enum ScanningStoreViewType {
    case scanning, scanningDone
}

final class ScanningStoreView: UIView {
    private var type: ScanningStoreViewType
    private var currentProgress: CGFloat = 0.0
    
    private lazy var titleLabel: Semibold24LabelStyle = Semibold24LabelStyle()
    
    private lazy var descriptionLabel: Regular13LabelStyle = {
        let label = Regular13LabelStyle()
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var progressBar: HorizontalProgressBar = HorizontalProgressBar()
    private lazy var broomImageView: UIImageView = UIImageView(image: .broom)
    
    init(type: ScanningStoreViewType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ type: ScanningStoreViewType, value: Double) {
        if self.type != type {
            self.type = type
            changeComponentsVisability()
        }
        
        switch type {
        case .scanning:
            currentProgress += CGFloat(value / 100)
            
            titleLabel.bind(text: "\(Int(currentProgress * 100))%")
            progressBar.updateProgress(to: currentProgress, duration: 0.1)
            descriptionLabel.bind(text: "Scanning your Storage...")
        case .scanningDone:
            let availableSize = NSAttributedString(string: String(Int(value)), attributes: [.foregroundColor: UIColor.purple])
            let available = NSMutableAttributedString(string: "Available ")
            available.append(availableSize)
            titleLabel.attributedText = available
            
            descriptionLabel.bind(text: "Unnecessary files for storage\noptimization have been identified")
        }
    }
    
    func resetProgress() {
        currentProgress = 0
        type = .scanning
        changeComponentsVisability()
        
        titleLabel.bind(text: "0%")
        descriptionLabel.bind(text: "Scanning your Storage...")
        progressBar.updateProgress(to: currentProgress)
    }
    
    private func changeComponentsVisability() {
        progressBar.isHidden = switch type {
        case .scanning: false
        case .scanningDone: true
        }
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
        layer.cornerRadius = 20
        addShadows()
        
        progressBar.backgroundView.frame = CGRect(origin: .zero, size: CGSize(width: 213, height: 12))
        resetProgress()
    }
    
    private func initConstraints() {
        addSubviews([titleLabel, descriptionLabel, progressBar, broomImageView])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            progressBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            progressBar.widthAnchor.constraint(equalToConstant: 213),
            
            broomImageView.topAnchor.constraint(equalTo: topAnchor, constant: -8),
            broomImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 4),
            broomImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4)
        ])
    }
}
