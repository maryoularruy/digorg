//
//  DuplicateNamesTableViewCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 17.02.2025.
//

import UIKit
import Contacts
import Reusable

enum DuplicateNamesTableViewCellType {
    case duplicateNames, allContacts
}

protocol DuplicateNamesTableViewCellDelegate: AnyObject {
    func tapOnSelectButton(row: Int)
    func tapOnCheckBox(selectedContacts: [CNContact], row: Int)
    func tapOnCell(contact: CNContact)
}

final class DuplicateNamesTableViewCell: UITableViewCell, Reusable {
    static var identifier = "DuplicateNamesTableViewCell"
    weak var delegate: DuplicateNamesTableViewCellDelegate?
    
    private lazy var duplicatesCountLabel: Regular15LabelStyle = Regular15LabelStyle()
    private lazy var selectionButton: SelectionTransparentButtonStyle = SelectionTransparentButtonStyle()
    
    private lazy var containerForInnerTableView = UIView()
    private lazy var containerForInnerTableViewHeight = containerForInnerTableView.heightAnchor.constraint(equalToConstant: (DuplicatesListCell.HEIGHT * Double(contacts.count)) + DuplicatesListCell.LAST_CELL_BOTTOM_CONSTRAINT)
    
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
    
    private lazy var spacerView: UIView = UIView()
    
    private lazy var contacts: [CNContact] = [CNContact]()
    private lazy var contactsForMerge: [CNContact] = [CNContact]()
    private lazy var position: Int = 0
    private lazy var duplicateNumber: String = ""
    
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
    
    func bind(_ contacts: [CNContact], type: DuplicateNamesTableViewCellType, position: Int, contactsForMerge: [CNContact]) {
        self.contacts = contacts
        self.contactsForMerge = contactsForMerge
        self.position = position
        
        switch type {
        case .duplicateNames:
            duplicatesCountLabel.bind(text: "\(contacts.count) duplicate contacts")
        case .allContacts:
            duplicatesCountLabel.bind(text: "\(String(describing: contacts.first?.givenName.first))")
        }
        
        selectionButton.bind(text: contactsForMerge.count == contacts.count ? .deselectAll : .selectAll)
        duplicatesListTableView.reloadData()
        containerForInnerTableViewHeight.constant = (DuplicatesListCell.HEIGHT * Double(contacts.count)) + DuplicatesListCell.LAST_CELL_BOTTOM_CONSTRAINT
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerForInnerTableView.backgroundColor = .clear
        containerForInnerTableView.layer.cornerRadius = 20
        containerForInnerTableView.addShadowsWithoutClipToBounds()
        containerForInnerTableViewHeight.priority = .init(600)
        duplicatesListTableView.clipsToBounds = true
        
        selectionButton.addTapGestureRecognizer { [weak self] in
            guard let self else { return }
            delegate?.tapOnSelectButton(row: position)
        }
    }
    
    private func initConstraints() {
        contentView.addSubviews([duplicatesCountLabel, selectionButton, containerForInnerTableView, spacerView])
        containerForInnerTableView.addSubviews([duplicatesListTableView])
        
        NSLayoutConstraint.activate([
            duplicatesCountLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            duplicatesCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            selectionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            selectionButton.centerYAnchor.constraint(equalTo: duplicatesCountLabel.centerYAnchor),
            
            containerForInnerTableView.topAnchor.constraint(equalTo: selectionButton.bottomAnchor, constant: 16),
            containerForInnerTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerForInnerTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerForInnerTableViewHeight,
            
            duplicatesListTableView.topAnchor.constraint(equalTo: containerForInnerTableView.topAnchor),
            duplicatesListTableView.leadingAnchor.constraint(equalTo: containerForInnerTableView.leadingAnchor),
            duplicatesListTableView.trailingAnchor.constraint(equalTo: containerForInnerTableView.trailingAnchor),
            duplicatesListTableView.bottomAnchor.constraint(equalTo: containerForInnerTableView.bottomAnchor),
            
            spacerView.topAnchor.constraint(equalTo: containerForInnerTableView.bottomAnchor),
            spacerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            spacerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            spacerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            spacerView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}

extension DuplicateNamesTableViewCell: DuplicatesListCellDelegate {
    func tapOnCell(contact: CNContact) {
        delegate?.tapOnCell(contact: contact)
    }
    
    func tapOnCheckBox(contact: CNContact) {
        delegate?.tapOnCheckBox(selectedContacts: contacts.count == 2 ? contacts : [contact], row: position)
    }
}

extension DuplicateNamesTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DuplicatesListCell.identifier, for: indexPath) as! DuplicatesListCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.bind(contacts[indexPath.row], position: indexPath.row, duplicateNumber: duplicateNumber, isSelected: contactsForMerge.contains(contacts[indexPath.row]), isLast: indexPath.row == contacts.count - 1)
        return cell
    }
}
