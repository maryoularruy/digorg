//
//  WidgetSmallPreview.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.03.2025.
//

import UIKit

final class WidgetSmallPreview: UIView {
    private var type: WidgetPreviewType
    
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
        label.numberOfLines = 2
        label.bind(text: type.smallInfoValue)
        return label
    }()
    
    private lazy var icon: UIImageView = UIImageView(image: type.smallImageWithWhiteBackground)
    
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
            
            icon.image = type.smallImageWithBlueBackground
            addShadows()
        } else {
            titleLabel.setLightGreyTextColor()
            defaultValueLabel.setPaleGreyTextColor()
            infoLabel.setLightGreyTextColor()
            infoValueLabel.setPaleGreyTextColor()
            
            icon.image = type.smallImageWithWhiteBackground
        }
    }
    
    private func setupView() {
        layer.cornerRadius = 20
        backgroundColor = .blue
    }
    
    private func initConstraints() {
        addSubviews([titleLabel, defaultValueLabel, icon, infoLabel, infoValueLabel])
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 160),
            widthAnchor.constraint(equalToConstant: 158),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            defaultValueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            defaultValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            icon.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            icon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            icon.heightAnchor.constraint(equalToConstant: 40),
            icon.widthAnchor.constraint(equalToConstant: 40),
            
            infoLabel.topAnchor.constraint(equalTo: defaultValueLabel.bottomAnchor, constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            infoValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            infoValueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
