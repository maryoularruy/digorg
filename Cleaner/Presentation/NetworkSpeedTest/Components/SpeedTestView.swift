//
//  SpeedTestView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 24.01.2025.
//

import UIKit

final class SpeedTestView: UIView {
    static var maxSpeedInMbps = 50.0
    
    private lazy var progressBar: SpeedTestProgressBar = SpeedTestProgressBar(frame: CGRect(origin: .zero, size: CGSize(width: 278, height: 278)))
    
    private lazy var currentValueLabel: Semibold24LabelStyle = {
        let label = Semibold24LabelStyle()
        label.bind(text: "0")
        return label
    }()
    
    private lazy var arrowAndMbpsView: ArrowAndMbpsView = ArrowAndMbpsView()
    
    private lazy var completedLabel: Semibold24LabelStyle = {
        let label = Semibold24LabelStyle()
        label.bind(text: "Completed")
        label.isHidden = true
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
    
    func bind(value: Double? = nil, type: SpeedTestType) {
        if let value {
            currentValueLabel.bind(text: value.formatted)
        }
        
        switch type {
        case .download:
            arrowAndMbpsView.arrowImageView.setImage(.downloadBlack)
        case .ping: break
        case .completed:
            currentValueLabel.isHidden = true
            arrowAndMbpsView.isHidden = true
            completedLabel.isHidden = false
            progressBar.progressAnimation(1.0)
        }
        progressBar.progressAnimation(1.0)
    }
    
    func reset() {
        currentValueLabel.bind(text: "0")
        arrowAndMbpsView.arrowImageView.setImage(.downloadBlack)
        currentValueLabel.isHidden = false
        arrowAndMbpsView.isHidden = false
        completedLabel.isHidden = true
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
        layer.cornerRadius = 20
        addShadows()
    }
    
    private func initConstraints() {
        addSubviews([progressBar, arrowAndMbpsView, currentValueLabel, completedLabel])
        
        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            progressBar.heightAnchor.constraint(equalToConstant: 278),
            progressBar.widthAnchor.constraint(equalToConstant: 278),
            progressBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            arrowAndMbpsView.centerXAnchor.constraint(equalTo: progressBar.centerXAnchor),
            arrowAndMbpsView.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor),
            
            currentValueLabel.bottomAnchor.constraint(equalTo: arrowAndMbpsView.topAnchor, constant: -7),
            currentValueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            completedLabel.bottomAnchor.constraint(equalTo: arrowAndMbpsView.bottomAnchor),
            completedLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
