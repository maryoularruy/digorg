//
//  WidgetView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 14.03.2025.
//

import UIKit

final class WidgetView: UIView {
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.bind(text: "Widgets")
        return label
    }()
    
    private lazy var widgetsHelpImageView: UIImageView = UIImageView(image: .widgetsHelp)
    
    lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Battery", "Storage"])
        sc.selectedSegmentIndex = 0
        sc.selectedSegmentTintColor = .blue
        
        sc.backgroundColor = .paleGrey
        sc.layer.cornerRadius = 12
        sc.layer.masksToBounds = true
        sc.addShadows()
        return sc
    }()
    
    private lazy var batteryWidgetPreview: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var toolbar: ActionToolbar = {
        let toolbar = ActionToolbar()
        toolbar.toolbarButton.bind(text: "Settings")
        return toolbar
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
    
    private func setupView() {
        backgroundColor = .paleGrey
    }
    
    private func initConstraints() {
        addSubviews([contentView, toolbar])
        
        contentView.addSubviews([arrowBack, label, widgetsHelpImageView, segmentedControl, batteryWidgetPreview])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            arrowBack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.5),
            arrowBack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            arrowBack.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBack.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            widgetsHelpImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            widgetsHelpImageView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            widgetsHelpImageView.heightAnchor.constraint(equalToConstant: 24),
            widgetsHelpImageView.widthAnchor.constraint(equalToConstant: 24),
            
            segmentedControl.topAnchor.constraint(equalTo: arrowBack.bottomAnchor, constant: 22),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 42),
            
            batteryWidgetPreview.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            batteryWidgetPreview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            batteryWidgetPreview.heightAnchor.constraint(equalToConstant: 158),
            batteryWidgetPreview.widthAnchor.constraint(equalToConstant: 158),
            
            toolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: bottomAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
