//
//  DuplicateNumberContactsView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.12.2024.
//

import UIKit

final class DuplicateNumberContactsView: UIView {
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
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(DuplicatesTableViewCell.self, forCellReuseIdentifier: DuplicatesTableViewCell.identifier)
        tableView.allowsMultipleSelection = true
        tableView.separatorStyle = .none
        tableView.clipsToBounds = true
        tableView.backgroundColor = .clear
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
    
    private func setupView() {
        backgroundColor = .paleGrey
    }
    
    private func initConstraints() {
        addSubviews([arrowBack, label, duplicatesCountLabel, selectionButton, duplicatesTableView, toolbar])
        
        NSLayoutConstraint.activate([
            arrowBack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
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
            duplicatesTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            toolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: bottomAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
