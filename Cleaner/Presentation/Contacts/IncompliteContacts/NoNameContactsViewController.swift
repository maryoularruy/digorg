//
//  IncompliteContactsViewController.swift
//  Cleaner
//
//  Created by Максим Лебедев on 20.10.2023.
//

import UIKit
import Contacts
import ContactsUI

class NoNameContactsViewController: UIViewController {
    @IBOutlet weak var arrowBackButton: UIView!
    @IBOutlet weak var unresolvedContactsCount: Regular13LabelStyle!
    @IBOutlet weak var unresolvedContactsTableView: UITableView!
    @IBOutlet weak var toolbar: ActionToolbar!
    
    private var contacts: [CNContact] = [] {
        didSet {
            unresolvedContactsCount.bind(text: "\(contacts.count) contact\(contacts.count == 1 ? "" : "s")")
            unresolvedContactsTableView.reloadData()
            if contacts.isEmpty {
                setupEmptyState()
            } else {
                toolbar.toolbarButton.bind(text: "Delete")
                toolbar.toolbarButton.isClickable = !contactsForDeletion.isEmpty
            }
        }
    }
    
    private var contactsForDeletion = Set<CNContact>() {
        didSet {
            toolbar.toolbarButton.isClickable = !contactsForDeletion.isEmpty
            unresolvedContactsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        reloadData()
        setupUnresolvedContactsTableView()
    }
    
    private func setupUnresolvedContactsTableView() {
        unresolvedContactsTableView.register(cellType: UnresolvedItemCell.self)
    }
    
    private func reloadData() {
        ContactManager.loadIncompletedByName { contacts in
            self.contacts = contacts
        }
    }
    
    private func presentContact(contact: CNContact) {
        if let contact = ContactManager.findContact(contact: contact) {
            let contactVC = CNContactViewController(for: contact)
            contactVC.allowsEditing = true
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationController?.pushViewController(contactVC, animated: true)
        }
    }
    
    private func setupEmptyState() {
        toolbar.toolbarButton.bind(text: "Back")
        toolbar.toolbarButton.isClickable = true
    }
}

extension NoNameContactsViewController: ViewControllerProtocol {
    func setupUI() {
        toolbar.delegate = self
    }
    
    func addGestureRecognizers() {
        arrowBackButton.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension NoNameContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as UnresolvedItemCell
        cell.delegate = self
        cell.bind(contact: contacts[indexPath.row], indexPath.row)
        
        cell.checkBoxButton.image = contactsForDeletion.contains(contacts[indexPath.row]) ? .selectedCheckBoxBlue : .emptyCheckBoxBlue
        
        cell.setupCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //72 height of the cell + 8 top&bottom insets
        88
    }
}

extension NoNameContactsViewController: UnresolvedItemCellProtocol {
    func tapOnCheckBox(_ position: (Int, Int)) {
        let contact = contacts[position.1]
        if contactsForDeletion.contains(contact) {
            contactsForDeletion.remove(contact)
        } else {
            contactsForDeletion.insert(contact)
        }
        
//        if contactsForMerge.count == sections.count {
//            tapOnSelectAllButton(self)
//        }
    }
    
    func tapOnCell(_ position: (Int, Int)) {
        presentContact(contact: contacts[position.1])
    }
}

extension NoNameContactsViewController: ActionToolbarDelegate {
    func tapOnActionButton() {
        if contacts.isEmpty {
            navigationController?.popViewController(animated: true)
        } else {
            ContactManager.delete(Array(contactsForDeletion))
            contactsForDeletion.removeAll()
            reloadData()
        }
    }
}
