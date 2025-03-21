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
        CustomSegmentedControlButton(index: WidgetPreviewType.battery.index, title: WidgetPreviewType.battery.title, isSelected: true),
        CustomSegmentedControlButton(index: WidgetPreviewType.storage.index, title: WidgetPreviewType.storage.title, isSelected: false)
    ])
    
    private lazy var widgetSmallPreviewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var batteryWidgetSmallPreview: WidgetSmallPreview = WidgetSmallPreview(type: .battery)
    private lazy var storageWidgetSmallPreview: WidgetSmallPreview = WidgetSmallPreview(type: .storage)
    
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
    
    func changeWigdetPreviews(index: Int) {
        guard let widgetType = WidgetPreviewType.allCases.first(where: { $0.index == index }) else { return }
        
        widgetSmallPreviewContainer.subviews.forEach { $0.removeFromSuperview() }
        
        switch widgetType {
        case .battery:
            widgetSmallPreviewContainer.addSubviews([batteryWidgetSmallPreview])
        case .storage:
            widgetSmallPreviewContainer.addSubviews([storageWidgetSmallPreview])
        }
        
        widgetSmallPreviewContainer.layoutIfNeeded()
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
        
        widgetSmallPreviewContainer.addSubviews([batteryWidgetSmallPreview])
        
        widgetsHelpImageView.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnWidgetHelp()
        }
    }
    
    private func initConstraints() {
        addSubviews([contentView, toolbar])
        
        contentView.addSubviews([arrowBack, label, widgetsHelpImageView, customSegmentedControl, widgetSmallPreviewContainer])
        
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
            
            widgetSmallPreviewContainer.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 20),
            widgetSmallPreviewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            toolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: bottomAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
