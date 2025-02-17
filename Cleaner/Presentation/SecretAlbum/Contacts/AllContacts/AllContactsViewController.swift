//
//  AllContactsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 06.11.2024.
//

import UIKit
import ContactsUI

final class AllContactsViewController: UIViewController {
    @IBOutlet weak var arrowBackView: UIView!
    @IBOutlet weak var contactsCountLabel: Regular13LabelStyle!
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var selectionButton: SelectionButtonStyle!
    @IBOutlet weak var toolbar: ActionToolbar!
    
    private lazy var sections: [CNContactSection] = [] {
        didSet {
            contactsCountLabel.bind(text: "\(allContactsCount) contact\(allContactsCount == 1 ? "" : "s")")
            selectionButton.isClickable = !sections.isEmpty
            contactsTableView.reloadData()
            if sections.isEmpty {
                setupEmptyState()
            } else {
                selectionButton.bind(text: contactsForImport.count == sections.count ? .deselectAll : .selectAll)
                toolbar.toolbarButton.bind(text: "Import Contacts (\(contactsForImport.count))")
                toolbar.toolbarButton.isClickable = !contactsForImport.isEmpty
            }
        }
    }
    
    private lazy var contactsForImport = Set<CNContact>() {
        didSet {
            selectionButton.bind(text: contactsForImport.count == allContactsCount ? .deselectAll : .selectAll)
            toolbar.toolbarButton.bind(text: "Import Contacts (\(contactsForImport.count))")
            toolbar.toolbarButton.isClickable = !contactsForImport.isEmpty
            contactsTableView.reloadData()
        }
    }
    
    private var allContactsCount: Int {
        sections.reduce(0) { $0 + $1.contacts.count }
    }
    
    private lazy var contactManager = ContactManager.shared
    private lazy var userDefaultsService = UserDefaultsService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        reloadData()
    }
    
    @IBAction func tapOnSelectionButton(_ sender: Any) {
        if contactsForImport.count == allContactsCount {
            contactsForImport.removeAll()
        } else {
            var contacts: [CNContact] = []
            sections.forEach { contacts.append(contentsOf: $0.contacts) }
            contactsForImport.insert(contacts)
        }
    }
    
    private func reloadData() {
        contactManager.loadAllContacts { contacts in
            self.sections = contacts
        }
    }
    
    private func setupEmptyState() {
        selectionButton.bind(text: .selectAll)
        toolbar.toolbarButton.bind(text: "Back")
        toolbar.toolbarButton.isClickable = true
    }
    
    private func presentContact(contact: CNContact) {
        if let contact = contactManager.findContact(contact: contact) {
            let contactVC = CNContactViewController(for: contact)
            contactVC.allowsEditing = true
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationController?.pushViewController(contactVC, animated: true)
        }
    }
}

extension AllContactsViewController: ViewControllerProtocol {
    func setupUI() {
        toolbar.delegate = self
        contactsTableView.register(cellType: ItemCell.self)
    }
    
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension AllContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ItemCellHeader()
        header.firstLabel.bind(text: sections[section].name)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        34
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].contacts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        86
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.clipsToBounds = false
        let cell = tableView.dequeueReusableCell(for: indexPath) as ItemCell
        cell.delegate = self
        
        if sections[indexPath.section].contacts.count != 1 {
            if indexPath.row == 0 {
                cell.setupFirstCellInSection()
            } else if indexPath.row == sections[indexPath.section].contacts.count - 1 {
                cell.setupLastCellInSection()
            } else {
                cell.setupMiddleCellInSection()
            }
        } else {
            cell.setupSingleCellInSection()
        }
        
        let contact = sections[indexPath.section].contacts[indexPath.row]
        cell.checkBoxButton.image = contactsForImport.contains(contact) ? .selectedCheckBoxBlue : .emptyCheckBoxBlue
        cell.backgroundColor = contactsForImport.contains(contact) ? .lightBlue : .paleGrey
        cell.bind(contact: contact, (indexPath.section, indexPath.row))
        
        return cell
    }
}

extension AllContactsViewController: ItemCellProtocol {
    func tapOnCheckBox(_ position: (Int, Int)) {
        let contact = sections[position.0].contacts[position.1]
        if contactsForImport.contains(contact) {
            contactsForImport.remove(contact)
        } else {
            contactsForImport.insert(contact)
        }
    }
    
    func tapOnCell(_ position: (Int, Int)) {
        presentContact(contact: sections[position.0].contacts[position.1])
    }
}

extension AllContactsViewController: ActionToolbarDelegate {
    func tapOnActionButton() {
        if sections.isEmpty {
            navigationController?.popViewController(animated: true)
        } else {
            contactManager.saveSecretContacts(Array(contactsForImport), removeFromGallery: userDefaultsService.isRemoveContactsAfterImport, cleanBeforeSaving: false)
            navigationController?.popViewController(animated: true)
        }
    }
}
