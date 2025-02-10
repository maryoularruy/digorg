//
//  SpeedTestCategoryView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.02.2025.
//

import UIKit

final class SpeedTestCategoryView: UIView {
    private var type: SpeedTestType
    
    private lazy var iconImageView = UIImageView(image: type.icon)
    
    private lazy var titleLabel: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.bind(text: type.title)
        return label
    }()
    
    private lazy var valueLabel: Regular15LabelStyle = {
        let label = Regular15LabelStyle()
        label.setGreyTextColor()
        label.bind(text: type.startValue)
        return label
    }()
    
    init(type: SpeedTestType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(newValue: Double) {
        switch type {
        case .download:
            valueLabel.bind(text: newValue.formatted + " Mbs")
        case .ping:
            valueLabel.bind(text: newValue.formatted + " ms")
        case .completed:
            break
        }
    }
    
    func reset() {
        valueLabel.bind(text: type.startValue)
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
        layer.cornerRadius = 20
        addShadows()
    }
    
    private func initConstraints() {
        addSubviews([iconImageView, titleLabel, valueLabel])
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)            
        ])
    }
}
