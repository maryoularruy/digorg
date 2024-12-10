//
//  ScanningGalleryProgressView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.12.2024.
//

import UIKit

final class ScanningGalleryProgressView: UIView {
    private lazy var contentView: UIView = UIView()
    lazy var progressLabel: Regular13LabelStyle = Regular13LabelStyle()
    lazy var progressBar: HorizontalProgressBar = HorizontalProgressBar()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        initConstraints()
    }
    
    func resetProgress() {
        progressBar.updateProgress(to: 0)
        progressLabel.bind(text: "\(progressBar.currentProgress.toPercent())% scanning your Gallery")
        layoutIfNeeded()
    }
    
    func updateProgress(_ progress: CGFloat) {
        progressBar.addProgress(progress)
        progressLabel.bind(text: "\(progressBar.currentProgress.toPercent())% scanning your Gallery")
        layoutIfNeeded()
    }
    
    private func setupView() {
        contentView.backgroundColor = .paleGrey
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        addShadows()
    }
    
    private func initConstraints() {
        addSubviews([contentView])
        contentView.addSubviews([progressLabel, progressBar])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            progressLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            progressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            progressBar.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 14),
            progressBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            progressBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
