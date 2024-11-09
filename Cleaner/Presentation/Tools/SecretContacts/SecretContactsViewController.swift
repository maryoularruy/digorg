//
//  SecretContactsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 06.11.2024.
//

import UIKit
import Contacts

final class SecretContactsViewController: UIViewController {
    @IBOutlet weak var arrowBackView: UIView!
    @IBOutlet weak var itemsCountLabel: Regular13LabelStyle!
    @IBOutlet weak var lockedStatusIcon: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var selectionButton: SelectionButtonStyle!
    @IBOutlet weak var contactsTableView: UITableView!
    
    private lazy var contacts: [CNContact] = [] {
        didSet {
            itemsCountLabel.bind(text: "\(contacts.count) contact\(contacts.count == 1 ? "" : "s")")
            selectionButton.isClickable = !contacts.isEmpty
            contactsTableView.reloadData()
            if contacts.isEmpty {
                setupEmptyState()
            } else {
                selectionButton.bind(text: contactsForDeletion.count == contacts.count ? .deselectAll : .selectAll)
                hideEmptyState()
            }
        }
    }
    
    private var contactsForDeletion = Set<CNContact>() {
        didSet {
            selectionButton.bind(text: contactsForDeletion.count == contacts.count ? .deselectAll : .selectAll)
//            toolbar.toolbarButton.bind(text: "Delete\(contactsForDeletion.isEmpty ? "" : " Selected (\(contactsForDeletion.count))")")
//            toolbar.toolbarButton.isClickable = !contactsForDeletion.isEmpty
            contactsTableView.reloadData()
        }
    }
    
    private lazy var emptyStateView: EmptyStateView? = nil
    private lazy var userDefaultsService = UserDefaultsService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupUI()
        reloadData()
    }
    
    @IBAction func tapOnAddButton(_ sender: Any) {
        let vc = StoryboardScene.AllContacts.initialScene.instantiate()
        vc.modalPresentationStyle = .overCurrentContext
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapOnSelectionButton(_ sender: Any) {
        if contactsForDeletion.count == contacts.count {
            contactsForDeletion.removeAll()
        } else {
            contactsForDeletion.insert(contacts)
        }
    }
    
    private func reloadData() {
        contacts = ContactManager.getSecretContacts() ?? []
    }
    
    private func setupEmptyState() {
        selectionButton.bind(text: .selectAll)
        emptyStateView?.removeFromSuperview()
        emptyStateView = view.createEmptyState(type: .emptySecretContacts)
        if let emptyStateView {
            view.addSubview(emptyStateView)
        }
    }
    
    private func hideEmptyState() {
        contactsTableView.reloadData()
        emptyStateView?.removeFromSuperview()
        emptyStateView = nil
    }
}

extension SecretContactsViewController: ViewControllerProtocol {
    func setupUI() {
        contactsTableView.register(cellType: ItemCell.self)
        lockedStatusIcon.image = userDefaultsService.isPasscodeCreated ? .locked :  .unlocked
    }
    
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension SecretContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as ItemCell
        cell.delegate = self
        cell.bind(contact: contacts[indexPath.row], indexPath.row)
        
        cell.checkBoxButton.image = contactsForDeletion.contains(contacts[indexPath.row]) ? .selectedCheckBoxBlue : .emptyCheckBoxBlue
        
        cell.content.backgroundColor = contactsForDeletion.contains(contacts[indexPath.row]) ? .lightBlueBackground : .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //72 height of the cell + 8 top&bottom insets
        88
    }
}

extension SecretContactsViewController: ItemCellProtocol {
    func tapOnCheckBox(_ position: (Int, Int)) {
        let contact = contacts[position.1]
        if contactsForDeletion.contains(contact) {
            contactsForDeletion.remove(contact)
        } else {
            contactsForDeletion.insert(contact)
        }
    }
    
    func tapOnCell(_ position: (Int, Int)) {}
}
