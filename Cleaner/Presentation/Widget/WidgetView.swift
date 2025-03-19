//
//  WidgetView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 14.03.2025.
//

import UIKit

protocol WidgetViewDelegate: AnyObject {
    func tapOnWidgetHelp()
}

final class WidgetView: UIView {
    weak var delegate: WidgetViewDelegate?
    
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.bind(text: "Widgets")
        return label
    }()
    
    private lazy var widgetsHelpImageView: UIImageView = UIImageView(image: .widgetsHelp)
    
    lazy var customSegmentedControl: CustomSegmentedControl = CustomSegmentedControl(buttons: [
        CustomSegmentedControlButton(index: 0, title: "Battery", isSelected: true),
        CustomSegmentedControlButton(index: 1, title: "Storage", isSelected: false)
    ])
    
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
        
        widgetsHelpImageView.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnWidgetHelp()
        }
    }
    
    private func initConstraints() {
        addSubviews([contentView, toolbar])
        
        contentView.addSubviews([arrowBack, label, widgetsHelpImageView, customSegmentedControl, batteryWidgetPreview])
        
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
            
            customSegmentedControl.topAnchor.constraint(equalTo: arrowBack.bottomAnchor, constant: 22),
            customSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customSegmentedControl.heightAnchor.constraint(equalToConstant: 42),
            
            batteryWidgetPreview.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 20),
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
