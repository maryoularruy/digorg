//
//  DuplicateContactsViewController.swift
//  Cleaner
//
//  Created by Максим Лебедев on 20.10.2023.
//

import UIKit
import Contacts
import ContactsUI

class DuplicateContactsViewController: UIViewController {
    @IBOutlet weak var arrowBackButton: UIView!
    @IBOutlet weak var unresolvedContactsCount: Regular13LabelStyle!
    @IBOutlet weak var unresolvedContactsTableView: UITableView!
    @IBOutlet weak var selectionButton: SelectionButtonStyle!
    @IBOutlet weak var toolbar: ActionAndCancelToolbar!
    //    @IBOutlet weak var blockView: UIView!
    //    @IBOutlet weak var deleteButton: UIButton!
//    @IBOutlet weak var checkBoxImage: UIImageView!
//    @IBOutlet weak var selectView: UIView!
//    @IBOutlet weak var noContactsStackView: UIStackView!
    
    private lazy var selectMode = false {
        didSet {
            if selectMode {
                contactsForMerge.insert(sections)
                selectionButton.bind(text: .deselectAll)
            } else {
                sections.forEach { contactsForMerge.remove($0) }
                selectionButton.bind(text: .selectAll)
                unresolvedContactsTableView.reloadData()
            }
        }
    }
    
    private lazy var sections = [[CNContact]]() {
        didSet {
            if sections.isEmpty {
//                noContactsStackView.isHidden = false
//                selectView.isHidden = true
            } else {
//                noContactsStackView.isHidden = true
//                selectView.isHidden = false
            }
        }
    }
    
    private lazy var contactsForMerge = Set<[CNContact]>() {
        didSet {
            unresolvedContactsCount.text = "\(sections.count) contact\(sections.count == 1 ? "" : "s")"
            unresolvedContactsTableView.reloadData()
            toolbar.isHidden = contactsForMerge.isEmpty
            toolbar.actionButton.bind(text: "Merge Contacts (\(sections.count))")
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
    
    @IBAction func tapOnSelectAllButton(_ sender: Any) {
        selectMode.toggle()
    }
    
    private func setupUnresolvedContactsTableView() {
        unresolvedContactsCount.bind(text: "\(sections.count) contact\(sections.count == 1 ? "" : "s")")
        unresolvedContactsTableView.register(cellType: UnresolvedItemCell.self)
    }
    
    private func reloadData() {
        ContactManager.loadContacts { [weak self] contacts in
            self?.sections = ContactManager.findDuplicateContacts(contacts: contacts)
//            print("SECTIO",self.contacts)
//            self.contacts = [contacts[5], contacts[6], contacts[7]]
//            self.collectionView.reloadData()
        }
    }
    
    private func presentContact(contact: CNContact) {
        do {
            let store = CNContactStore()
            let descriptor = CNContactViewController.descriptorForRequiredKeys()
            let editContact = try store.unifiedContact(withIdentifier: contact.identifier, keysToFetch: [descriptor])
            let contactVC = CNContactViewController(for: editContact)
            contactVC.allowsEditing = true
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationController?.pushViewController(contactVC, animated: true)
        } catch {
            print(error)
        }
    }
}

extension DuplicateContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections.reduce(0) { $0 + $1.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.clipsToBounds = false
        let cell = tableView.dequeueReusableCell(for: indexPath) as UnresolvedItemCell
        cell.delegate = self
        if indexPath.row == 0 {
            cell.setupFirstCellInSection()
        } else if indexPath.row == sections[indexPath.section].count - 1 {
            cell.setupLastCellInSection()
        }
        
        cell.checkBoxButton.image = contactsForMerge.contains(sections[indexPath.section]) ? .selectedCheckBoxBlue : .emptyCheckBoxBlue
        
        cell.bind(contact: sections[indexPath.section][indexPath.row], (indexPath.section, indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UnresolvedItemCellHeader()
        header.unresolvedItemsInSection.bind(text: "\(sections[section].count) duplicates")
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        34
    }
}

extension DuplicateContactsViewController: UnresolvedItemCellProtocol {
    func tapOnCheckBox(_ position: (Int, Int)) {
        let duplicateContacts = sections[position.0]
        if contactsForMerge.contains(duplicateContacts) {
            contactsForMerge.remove(duplicateContacts)
        } else {
            contactsForMerge.insert(duplicateContacts)
        }
        
        if contactsForMerge.count == sections.count {
            tapOnSelectAllButton(self)
        }
    }
    
    func tapOnCell(_ position: (Int, Int)) {
        
    }
}

extension DuplicateContactsViewController: ViewControllerProtocol {
    func setupUI() {
        toolbar.delegate = self
    }
    
    func addGestureRecognizers() {
        arrowBackButton.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension DuplicateContactsViewController: ActionAndCancelToolbarProtocol {
    func tapOnAction() {
        guard let vc = UIStoryboard(name: ConfirmActionViewController.idenfifier, bundle: .main).instantiateViewController(identifier: ConfirmActionViewController.idenfifier) as? ConfirmActionViewController else { return }
        vc.height = 238
        vc.actionButtonText = "Merge Contacts (\(sections.count))"
        vc.type = .contactMerge
        DispatchQueue.main.async { [weak self] in
            self?.present(vc, animated: true, completion: nil)
        }
    }
    
    func tapOnCancel() {
        selectMode = false
        reloadData()
    }
}
