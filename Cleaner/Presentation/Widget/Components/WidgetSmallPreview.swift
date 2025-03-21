//
//  WidgetSmallPreview.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.03.2025.
//

import UIKit

enum WidgetPreviewType: CaseIterable {
    case battery, storage
    
    var index: Int {
        switch self {
        case .battery: 0
        case .storage: 1
        }
    }
    
    var title: String {
        switch self {
        case .battery: "Battery"
        case .storage: "Storage"
        }
    }
    
    var defaultValue: String {
        switch self {
        case .battery: "25 %"
        case .storage: "87 %"
        }
    }
    
    var info: String {
        switch self {
        case .battery: "No activity"
        case .storage: "Storage Usage"
        }
    }
    
    var infoValue: String {
        switch self {
        case .battery: "Low power mode\ndisabled"
        case .storage: "112GB / 128 GB"
        }
    }
    
    var image: UIImage {
        switch self {
        case .battery: UIImage(resource: .batteryWidgetIcon)
            //TODO: -add storage widget icon
        case .storage: UIImage(resource: .batteryWidgetIcon)
        }
    }
}

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
        label.bind(text: type.infoValue)
        return label
    }()
    
    private lazy var icon: UIImageView = UIImageView(image: type.image)
    
    init(type: WidgetPreviewType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateBackgroundColor() {
        
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
