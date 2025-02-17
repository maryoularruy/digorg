//
//  DuplicateNamesTableViewCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 17.02.2025.
//

import UIKit
import Contacts
import Reusable

protocol DuplicateNamesTableViewCellDelegate: AnyObject {
    func tapOnSelectButton(row: Int)
    func tapOnCheckBox(selectedContacts: [CNContact], row: Int)
    func tapOnCell(contact: CNContact)
    func tapOnMergeContacts(contactsForMerge: [CNContact], row: Int)
}

final class DuplicateNamesTableViewCell: UITableViewCell, Reusable {
    static var identifier = "DuplicateNamesTableViewCell"
    weak var delegate: DuplicateNamesTableViewCellDelegate?
    
    private lazy var duplicateNumberLabel: Semibold15LabelStyle = Semibold15LabelStyle()
    lazy var selectionButton: SelectionTransparentButtonStyle = SelectionTransparentButtonStyle()
    
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
    
    private lazy var mergeContactsButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 16.0
        button.layer.cornerCurve = .circular
        button.setTitle("Merge Contacts", for: .normal)
        button.setTitleColor(.paleGrey, for: .normal)
        button.titleLabel?.font = .medium12
        button.tintColor = .paleGrey
        button.addTarget(self, action: #selector(tapOnMergeContactsButton), for: .touchUpInside)
        return button
    }()
    private lazy var mergeContactsButtonHeight = mergeContactsButton.heightAnchor.constraint(equalToConstant: 0)
    
    private lazy var spacerView: UIView = UIView()
    private lazy var spacerViewHeight = spacerView.heightAnchor.constraint(equalToConstant: 8)
    
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
    
    func bind(_ contacts: [CNContact], position: Int, contactsForMerge: [CNContact]) {
        self.contacts = contacts
        self.contactsForMerge = contactsForMerge
        self.position = position
//        if let number = contactManager.findDuplicatedNumber(contacts) {
//            duplicateNumber = number
//            duplicateNumberLabel.bind(text: number)
//        }
        selectionButton.bind(text: contactsForMerge.count == contacts.count ? .deselectAll : .selectAll)
        duplicatesListTableView.reloadData()
        containerForInnerTableViewHeight.constant = (DuplicatesListCell.HEIGHT * Double(contacts.count)) + DuplicatesListCell.LAST_CELL_BOTTOM_CONSTRAINT
        mergeContactsButtonHeight.constant = contactsForMerge.count >= 2 ? 32.0 : 0.0
        spacerViewHeight.constant = contactsForMerge.count >= 2 ? 24.0 : 8.0
    }
    
    @objc func tapOnMergeContactsButton() {
        delegate?.tapOnMergeContacts(contactsForMerge: contactsForMerge, row: position)
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
        contentView.addSubviews([duplicateNumberLabel, selectionButton, containerForInnerTableView, mergeContactsButton, spacerView])
        containerForInnerTableView.addSubviews([duplicatesListTableView])
        
        NSLayoutConstraint.activate([
            duplicateNumberLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            duplicateNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            selectionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            selectionButton.centerYAnchor.constraint(equalTo: duplicateNumberLabel.centerYAnchor),
            
            containerForInnerTableView.topAnchor.constraint(equalTo: selectionButton.bottomAnchor, constant: 16),
            containerForInnerTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerForInnerTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerForInnerTableViewHeight,
            
            duplicatesListTableView.topAnchor.constraint(equalTo: containerForInnerTableView.topAnchor),
            duplicatesListTableView.leadingAnchor.constraint(equalTo: containerForInnerTableView.leadingAnchor),
            duplicatesListTableView.trailingAnchor.constraint(equalTo: containerForInnerTableView.trailingAnchor),
            duplicatesListTableView.bottomAnchor.constraint(equalTo: containerForInnerTableView.bottomAnchor),
            
            mergeContactsButton.topAnchor.constraint(equalTo: containerForInnerTableView.bottomAnchor, constant: 16),
            mergeContactsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mergeContactsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mergeContactsButtonHeight,
            
            spacerView.topAnchor.constraint(equalTo: mergeContactsButton.bottomAnchor),
            spacerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            spacerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            spacerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            spacerViewHeight
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
