//
//  CleaningItemsView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.12.2024.
//

import UIKit

final class CleaningItemsView: UIView {
    private lazy var progressLabel: Semibold24LabelStyle = Semibold24LabelStyle()
    
    private lazy var cleaningItemsLabel: Regular15LabelStyle = {
        let label = Regular15LabelStyle()
        label.bind(text: "Cleaning unnecessary files....")
        return label
    }()
    
    private lazy var progressBar: HorizontalProgressBar = HorizontalProgressBar()
    
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
        backgroundColor = .paleGrey
    }
    
    private func initConstraints() {
        addSubviews([progressLabel, cleaningItemsLabel, progressBar])
        
        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            
            cleaningItemsLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 16),
            cleaningItemsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            progressBar.topAnchor.constraint(equalTo: cleaningItemsLabel.bottomAnchor, constant: 16),
            progressBar.widthAnchor.constraint(equalTo: cleaningItemsLabel.widthAnchor)
        ])
    }
}
