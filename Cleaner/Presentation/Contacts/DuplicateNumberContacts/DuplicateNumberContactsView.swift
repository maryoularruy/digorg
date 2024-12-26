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
    lazy var toolbar: ActionToolbar = ActionToolbar()
    
    lazy var duplicatesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DuplicatesTableViewCell.self, forCellReuseIdentifier: DuplicatesTableViewCell.identifier)
        tableView.allowsMultipleSelection = true
        tableView.separatorStyle = .none
        tableView.clipsToBounds = true
        return tableView
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
    }
    
    private func initConstraints() {
        addSubviews([scrollView, toolbar])
        scrollView.addSubviews([arrowBack, label, duplicatesCountLabel, selectionButton, duplicatesTableView])
        
        duplicatesTableView.backgroundColor = .red
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            arrowBack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            arrowBack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            arrowBack.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBack.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
            
            label.topAnchor.constraint(equalTo: arrowBack.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            duplicatesCountLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6),
            duplicatesCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            selectionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            selectionButton.centerYAnchor.constraint(equalTo: arrowBack.centerYAnchor),
            
            duplicatesTableView.topAnchor.constraint(equalTo: duplicatesCountLabel.bottomAnchor, constant: 20),
            duplicatesTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            duplicatesTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            duplicatesTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            duplicatesTableView.heightAnchor.constraint(equalToConstant: 400),
            
            toolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: bottomAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
