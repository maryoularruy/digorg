//
//  NetworkSpeedTestView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 24.01.2025.
//

import UIKit

enum SpeedTestType {
    case download, upload, completed
}

final class NetworkSpeedTestView: UIView {
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var label: Semibold24LabelStyle = {
        let label = Semibold24LabelStyle()
        label.bind(text: "Speed Test")
        return label
    }()
    
    lazy var speedTestView = SpeedTestView()
    
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
        addSubviews([contentView])
        contentView.addSubviews([arrowBack, label, speedTestView])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            arrowBack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.5),
            arrowBack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            arrowBack.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBack.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
            
            label.topAnchor.constraint(equalTo: arrowBack.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            speedTestView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            speedTestView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            speedTestView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            speedTestView.heightAnchor.constraint(equalToConstant: 259)
        ])
    }
}
