//
//  DeviceInfoCategoryView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 13.01.2025.
//

import UIKit

enum DeviceInfoCategoryType {
    case ram, download, cpu
    
    var title: String {
        switch self {
        case .ram: "RAM"
        case .download: "Download Speed"
        case .cpu: "CPU"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .ram: .ramIcon
        case .download: .downloadIcon
        case .cpu: .cpuIcon
        }
    }
    
    var hint: String {
        switch self {
        case .ram: "available"
        case .download: "/ sec"
        case .cpu: "used"
        }
    }
    
    var description: String {
        switch self {
        case .ram:
            "Random-access memory (RAM) stores data used by the processor. The more memory, the more operations the processor can handle without slowing down. If there is not enough memory, the system may freeze."
        case .download:
            "If the loading speed is 0 KB/s, it means there is no background activity. If the speed is around 1 MB/s, background processes are occurring. Speeds above 1 MB/s indicate an active process (file downloads, video calls, etc.)."
        case .cpu:
            "The processor is responsible for data processing. In the background mode, its power is used at 10%, while under load - at 98-99%. The system may freeze if the processor is utilized more than 85%."
        }
    }
}

final class DeviceInfoCategoryView: UIView {
    private var type: DeviceInfoCategoryType
    
    private lazy var contentView: UIView = UIView()
    private lazy var iconImageView: UIImageView = UIImageView()
    private lazy var titleLabel: Semibold15LabelStyle = Semibold15LabelStyle()
    private lazy var actualValueLabel: Semibold15LabelStyle = Semibold15LabelStyle()
    private lazy var hintLabel: Regular11LabelStyle = Regular11LabelStyle()
    
    private lazy var descriptionLabel: Regular13LabelStyle = {
        let label = Regular13LabelStyle()
        label.numberOfLines = 0
        return label
    }()
    
    init(type: DeviceInfoCategoryType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(value: Any) {
        switch type {
        case .ram:
            actualValueLabel.bind(text: (value as! UInt64).roundAndToString() + " / " + DeviceInfoService.totalRam)
        case .download:
            actualValueLabel.bind(text: (value as! Int) == 0 ? "0 KB" : (value as! Int).toStringWithDot())
        case .cpu:
            actualValueLabel.bind(text: "\(String(format: "%.1f", value as! CVarArg)) %")
        }
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .paleGrey
        contentView.layer.cornerRadius = 24
        contentView.addShadows()
        
        iconImageView.setImage(type.icon)
        titleLabel.bind(text: type.title)
        hintLabel.bind(text: type.hint)
        descriptionLabel.bind(text: type.description)
        
        if type == .ram {
            actualValueLabel.bind(text: DeviceInfoService.totalRam)
        }
    }
    
    private func initConstraints() {
        addSubviews([contentView])
        contentView.addSubviews([iconImageView, titleLabel, actualValueLabel, hintLabel, descriptionLabel])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            
            actualValueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 19),
            actualValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            hintLabel.topAnchor.constraint(equalTo: actualValueLabel.bottomAnchor, constant: 1),
            hintLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
