//
//  SmartCleanView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 04.02.2025.
//

import UIKit

final class SmartCleanView: UIView {
    private lazy var scroll: UIScrollView = scrollView
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.bind(text: "Smart Clean")
        return label
    }()
    
    lazy var scanningStoreView: ScanningStoreView = ScanningStoreView(type: .scanning)
    
    lazy var actionToolbar: ActionToolbar = {
        let toolbar = ActionToolbar()
        toolbar.toolbarButton.isClickable = false
        toolbar.toolbarButton.bind(text: "Delete all")
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
        addSubviews([scroll, actionToolbar])
        scroll.addSubviews([contentView])
        contentView.addSubviews([arrowBack, label, scanningStoreView])
        
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scroll.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -90),
            contentView.widthAnchor.constraint(equalTo: scroll.widthAnchor, constant: -32),
            
            arrowBack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            arrowBack.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            arrowBack.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBack.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            scanningStoreView.topAnchor.constraint(equalTo: arrowBack.bottomAnchor, constant: 18),
            scanningStoreView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scanningStoreView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scanningStoreView.heightAnchor.constraint(equalToConstant: 108),
            
            actionToolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionToolbar.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionToolbar.bottomAnchor.constraint(equalTo: bottomAnchor),
            actionToolbar.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
