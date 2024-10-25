//
//  NoNumberContactsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.10.2024.
//

import ContactsUI

final class NoNumberContactsViewController: UIViewController {
    @IBOutlet weak var arrowBackButton: UIView!
    @IBOutlet weak var unresolvedContactsCount: Regular13LabelStyle!
    @IBOutlet weak var unresolvedContactsTableView: UITableView!
    
    private var contacts: [CNContact] = [] {
        didSet {
            unresolvedContactsCount.bind(text: "\(contacts.count) contact\(contacts.count == 1 ? "" : "s")")
            unresolvedContactsTableView.reloadData()
        }
    }
    
    private var contactsForDeletion = Set<CNContact>() {
        didSet {
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
        reloadData()
        setupUnresolvedContactsTableView()
    }
    
    private func setupUnresolvedContactsTableView() {
        unresolvedContactsTableView.register(cellType: UnresolvedItemCell.self)
    }
    
    private func reloadData() {
        ContactManager.loadIncompletedByNumber { contacts in
            self.contacts = contacts
        }
    }
    
    private func presentContact(contact: CNContact) {
        if let contact = ContactManager.findContact(contact: contact) {
            let contactVC = CNContactViewController(for: contact)
            contactVC.allowsEditing = true
            navigationController?.pushViewController(contactVC, animated: true)
        }
    }
}

extension NoNumberContactsViewController: ViewControllerProtocol {
    func setupUI() {}
    
    func addGestureRecognizers() {
        arrowBackButton.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension NoNumberContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as UnresolvedItemCell
        cell.delegate = self
        cell.bindNoNumber(contact: contacts[indexPath.row], indexPath.row)
        
        cell.checkBoxButton.image = contactsForDeletion.contains(contacts[indexPath.row]) ? .selectedCheckBoxBlue : .emptyCheckBoxBlue
        
        cell.setupCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //72 height of the cell + 8 top&bottom insets
        88
    }
}

extension NoNumberContactsViewController: UnresolvedItemCellProtocol {
    func tapOnCheckBox(_ position: (Int, Int)) {
        let contact = contacts[position.1]
        if contactsForDeletion.contains(contact) {
            contactsForDeletion.remove(contact)
        } else {
            contactsForDeletion.insert(contact)
        }
    }
    
    func tapOnCell(_ position: (Int, Int)) {
        presentContact(contact: contacts[position.1])
    }
}
