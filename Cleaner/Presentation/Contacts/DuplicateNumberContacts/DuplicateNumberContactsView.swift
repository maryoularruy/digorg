//
//  DuplicateNumberContactsView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.12.2024.
//

import UIKit

final class DuplicateNumberContactsView: UIView {
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.refreshControl = UIRefreshControl()
        return scrollView
    }()
    
    lazy var arrowBack: UIImageView = arrowBackButton
    
    private lazy var label: Semibold24LabelStyle = {
        let label = Semibold24LabelStyle()
        label.bind(text: "Duplicate Numbers")
        return label
    }()
    
    lazy var duplicatesCountLabel: Regular13LabelStyle = Regular13LabelStyle()
    lazy var selectionButton: SelectionButtonStyle = SelectionButtonStyle()
    
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
        addSubviews([scrollView])
        scrollView.addSubviews([arrowBack, label, duplicatesCountLabel, selectionButton])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
//            scrollView.topAnchor.constraint(equalTo: topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            arrowBack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            arrowBack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            arrowBack.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBack.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
            
            label.topAnchor.constraint(equalTo: arrowBack.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            
            duplicatesCountLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6),
            duplicatesCountLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            
            selectionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            selectionButton.centerYAnchor.constraint(equalTo: arrowBack.centerYAnchor)
        ])
    }
}
