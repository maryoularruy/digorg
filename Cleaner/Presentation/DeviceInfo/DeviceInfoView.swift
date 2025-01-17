//
//  DeviceInfoView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.01.2025.
//

import UIKit

final class DeviceInfoView: UIView {
    lazy var scroll: UIScrollView = scrollView
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.bind(text: "Device Info")
        return label
    }()
    
    lazy var ramView: DeviceInfoCategoryView = DeviceInfoCategoryView(type: .ram)
    lazy var downloadView: DeviceInfoCategoryView = DeviceInfoCategoryView(type: .download)
    lazy var cpuView: DeviceInfoCategoryView = DeviceInfoCategoryView(type: .cpu)
    
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
        
        scroll.showsVerticalScrollIndicator = false
    }
    
    private func initConstraints() {
        addSubviews([scroll])
        scroll.addSubviews([contentView])
        contentView.addSubviews([arrowBack, label, ramView, downloadView, cpuView])
        
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scroll.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -10),
            contentView.widthAnchor.constraint(equalTo: scroll.widthAnchor, constant: -32),
            
            arrowBack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            arrowBack.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            arrowBack.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBack.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            ramView.topAnchor.constraint(equalTo: arrowBack.bottomAnchor, constant: 16),
            ramView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ramView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            downloadView.topAnchor.constraint(equalTo: ramView.bottomAnchor, constant: 8),
            downloadView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            downloadView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            cpuView.topAnchor.constraint(equalTo: downloadView.bottomAnchor, constant: 8),
            cpuView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cpuView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cpuView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
