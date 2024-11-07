//
//  AllContactsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 06.11.2024.
//

import UIKit
import Contacts

final class AllContactsViewController: UIViewController {
    @IBOutlet weak var arrowBackView: UIView!
    @IBOutlet weak var contactsCountLabel: Regular13LabelStyle!
    @IBOutlet weak var contactsTableView: UITableView!
    
    private lazy var contacts: [CNContactSection] = [] {
        didSet {
            contactsCountLabel.bind(text: "\(contacts.count) contact\(contacts.count == 1 ? "" : "s")")
        }
    }
    
    private lazy var contactsForImport = Set<CNContact>() {
        didSet {
            
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
    }
    
    private func reloadData() {
        ContactManager.loadAllContacts { contacts in
            self.contacts = contacts
        }
    }
}

extension AllContactsViewController: ViewControllerProtocol {
    func setupUI() {
        contactsTableView.register(cellType: UnresolvedItemCell.self)
    }
    
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension AllContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UnresolvedItemCellHeader()
        header.firstLabel.bind(text: contacts[section].name)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        34
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts[section].contacts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        86
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.clipsToBounds = false
        let cell = tableView.dequeueReusableCell(for: indexPath) as UnresolvedItemCell
        cell.delegate = self
        if indexPath.row == 0 {
            cell.setupFirstCellInSection()
        } else if indexPath.row == contacts[indexPath.section].contacts.endIndex {
            cell.setupLastCellInSection()
        }
        
        cell.checkBoxButton.image = contactsForImport.contains(contacts[indexPath.section].contacts[indexPath.row]) ? .selectedCheckBoxBlue : .emptyCheckBoxBlue
        
        cell.bind(contact: contacts[indexPath.section].contacts[indexPath.row], (indexPath.section, indexPath.row))
        return cell
    }
}

extension AllContactsViewController: UnresolvedItemCellProtocol {
    func tapOnCheckBox(_ position: (Int, Int)) {
        
    }
    
    func tapOnCell(_ position: (Int, Int)) {
        
    }
}
