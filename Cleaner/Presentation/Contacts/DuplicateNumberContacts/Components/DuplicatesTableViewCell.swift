//
//  DuplicatesTableViewCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.12.2024.
//

import UIKit
import Contacts

protocol DuplicatesTableViewCellDelegate: AnyObject {
    func tapOnSelectButton(position: Int)
}

final class DuplicatesTableViewCell: UITableViewCell {
    static var identifier = "DuplicatesTableViewCell"
    weak var delegate: DuplicatesTableViewCellDelegate?
    
    private lazy var duplicateNumberLabel: Semibold15LabelStyle = Semibold15LabelStyle()
    private lazy var selectionButton: SelectionTransparentButtonStyle = SelectionTransparentButtonStyle()
    private lazy var containerForInnerTableView = UIView()
    
    private lazy var duplicatesListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(DuplicatesListCell.self, forCellReuseIdentifier: DuplicatesListCell.identifier)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var contacts: [CNContact] = [CNContact]()
    private lazy var position: Int = 0
    
    private lazy var contactManager = ContactManager.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
        initConstraints()
    }
    
    func bind(_ contacts: [CNContact], position: Int) {
        self.contacts = contacts
        self.position = position
        if let number = contactManager.findDuplicatedNumber(contacts) {
            duplicateNumberLabel.bind(text: number)
        }
        selectionButton.bind(text: .selectAll)
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        selectionButton.delegate = self
        
        containerForInnerTableView.backgroundColor = .paleGrey
        containerForInnerTableView.layer.cornerRadius = 20
        containerForInnerTableView.addShadowsWithoutClipToBounds()
    }
    
    private func initConstraints() {
        addSubviews([duplicateNumberLabel, selectionButton, containerForInnerTableView])
        
        NSLayoutConstraint.activate([
            duplicateNumberLabel.topAnchor.constraint(equalTo: topAnchor),
            duplicateNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            selectionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            selectionButton.centerYAnchor.constraint(equalTo: duplicateNumberLabel.centerYAnchor),
            
            containerForInnerTableView.topAnchor.constraint(equalTo: selectionButton.bottomAnchor, constant: 16),
            containerForInnerTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerForInnerTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerForInnerTableView.heightAnchor.constraint(equalToConstant: 100),
            containerForInnerTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension DuplicatesTableViewCell: SelectionButtonDelegate {
    func tapOnButton() {
        delegate?.tapOnSelectButton(position: position)
    }
}

extension DuplicatesTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
