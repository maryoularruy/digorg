//
//  DuplicatesTableViewCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.12.2024.
//

import UIKit
import Contacts

protocol DuplicatesTableViewCellDelegate: AnyObject {
    func tapOnSelectButton(rowPosition: Int)
    func tapOnCheckBox(contact: [CNContact])
    func tapOnCell(contact: CNContact)
}

final class DuplicatesTableViewCell: UITableViewCell {
    static var identifier = "DuplicatesTableViewCell"
    weak var delegate: DuplicatesTableViewCellDelegate?
    
    private lazy var duplicateNumberLabel: Semibold15LabelStyle = Semibold15LabelStyle()
    lazy var selectionButton: SelectionTransparentButtonStyle = SelectionTransparentButtonStyle()
    
    private lazy var containerForInnerTableView = UIView()
    private lazy var containerForInnerTableViewHeight = containerForInnerTableView.heightAnchor.constraint(equalToConstant: DuplicatesListCell.HEIGHT + 8.0)
    
    private lazy var duplicatesListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(DuplicatesListCell.self, forCellReuseIdentifier: DuplicatesListCell.identifier)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        tableView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 20
        tableView.backgroundColor = .paleGrey
        return tableView
    }()
    
    private lazy var contacts: [CNContact] = [CNContact]()
    private lazy var contactsForMerge: [CNContact]? = nil
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
    
    func bind(_ contacts: [CNContact], position: Int, contactsForMerge: [CNContact]?) {
        self.contacts = contacts
        self.contactsForMerge = contactsForMerge
        self.position = position
        if let number = contactManager.findDuplicatedNumber(contacts) {
            duplicateNumberLabel.bind(text: number)
        }
        selectionButton.bind(text: contactsForMerge?.count == contacts.count ? .deselectAll : .selectAll)
        duplicatesListTableView.reloadData()
        containerForInnerTableViewHeight.constant = (DuplicatesListCell.HEIGHT * Double(contacts.count)) + 8.0
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerForInnerTableView.backgroundColor = .paleGrey
        containerForInnerTableView.layer.cornerRadius = 20
        containerForInnerTableView.addShadowsWithoutClipToBounds()
        containerForInnerTableViewHeight.priority = .init(600)
        duplicatesListTableView.clipsToBounds = true
        
        selectionButton.addTapGestureRecognizer { [weak self] in
            guard let self else { return }
            delegate?.tapOnSelectButton(rowPosition: position)
        }
    }
    
    private func initConstraints() {
        contentView.addSubviews([duplicateNumberLabel, selectionButton, containerForInnerTableView])
        containerForInnerTableView.addSubviews([duplicatesListTableView])
        
        NSLayoutConstraint.activate([
            duplicateNumberLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            duplicateNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            selectionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            selectionButton.centerYAnchor.constraint(equalTo: duplicateNumberLabel.centerYAnchor),
            
            containerForInnerTableView.topAnchor.constraint(equalTo: selectionButton.bottomAnchor, constant: 16),
            containerForInnerTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerForInnerTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerForInnerTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            containerForInnerTableViewHeight,
            
            duplicatesListTableView.topAnchor.constraint(equalTo: containerForInnerTableView.topAnchor),
            duplicatesListTableView.leadingAnchor.constraint(equalTo: containerForInnerTableView.leadingAnchor),
            duplicatesListTableView.trailingAnchor.constraint(equalTo: containerForInnerTableView.trailingAnchor),
            duplicatesListTableView.bottomAnchor.constraint(equalTo: containerForInnerTableView.bottomAnchor, constant: -8)
        ])
    }
}

extension DuplicatesTableViewCell: DuplicatesListCellDelegate {
    func tapOnCell(contact: CNContact) {
        delegate?.tapOnCell(contact: contact)
    }
    
    func tapOnCheckBox(contact: CNContact) {
//        delegate?.tapOnCheckBox(contact: contact)
    }
}

extension DuplicatesTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DuplicatesListCell.identifier, for: indexPath) as! DuplicatesListCell
        cell.delegate = self
        cell.bind(contacts[indexPath.row], position: indexPath.row)
        
        if let contactsForMerge {
            cell.checkBox.setImage(contactsForMerge.contains(contacts[indexPath.row]) ? .selectedCheckBoxBlue : .emptyCheckBoxBlue)
        } else {
            cell.checkBox.setImage(.emptyCheckBoxBlue)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        DuplicatesListCell.HEIGHT
    }
}
