//
//  WidgetMediumPreview.swift
//  Cleaner
//
//  Created by Elena Sedunova on 21.03.2025.
//

import UIKit

final class WidgetMediumPreview: UIView {
    private var type: WidgetPreviewType
    
    private lazy var contentView = UIView()
    
    private lazy var titleLabel: Regular13LabelStyle = {
        let label = Regular13LabelStyle()
        label.setLightGreyTextColor()
        label.bind(text: type.title)
        return label
    }()
    
    private lazy var defaultValueLabel: Semibold24LabelStyle = {
        let label = Semibold24LabelStyle()
        label.setPaleGreyTextColor()
        label.bind(text: type.defaultValue)
        return label
    }()
    
    private lazy var infoLabel: Regular13LabelStyle = {
        let label = Regular13LabelStyle()
        label.setLightGreyTextColor()
        label.bind(text: type.info)
        return label
    }()
    
    private lazy var infoValueLabel: Medium13LabelStyle = {
        let label = Medium13LabelStyle()
        label.bind(text: type.mediumInfoValue)
        return label
    }()
    
    private lazy var iconWithShadow: UIImageView = UIImageView(image: type.mediumImageWithWhiteBackground)
    
    init(type: WidgetPreviewType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateBackgroundColor(color: UIColor) {
        backgroundColor = color
        
        setStyles(isWhiteBackground: color == .paleGrey)
    }
    
    private func setStyles(isWhiteBackground: Bool) {
        if isWhiteBackground {
            titleLabel.setDarkGreyTextColor()
            defaultValueLabel.setBlackTextColor()
            infoLabel.setDarkGreyTextColor()
            infoValueLabel.setBlackTextColor()
            
            iconWithShadow.image = type.mediumImageWithBlueBackground
            addShadows()
        } else {
            titleLabel.setLightGreyTextColor()
            defaultValueLabel.setPaleGreyTextColor()
            infoLabel.setLightGreyTextColor()
            infoValueLabel.setPaleGreyTextColor()
            
            iconWithShadow.image = type.mediumImageWithWhiteBackground
        }
    }
    
    private func setupView() {
        layer.cornerRadius = 20
        backgroundColor = .blue
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }
    
    private func initConstraints() {
        addSubviews([contentView])
        contentView.addSubviews([titleLabel, defaultValueLabel, infoLabel, infoValueLabel, iconWithShadow])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            defaultValueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            defaultValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            infoLabel.topAnchor.constraint(equalTo: defaultValueLabel.bottomAnchor, constant: 8),
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            infoValueLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 4),
            infoValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoValueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            iconWithShadow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 121),
            iconWithShadow.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 120)
        ])
    }
}
