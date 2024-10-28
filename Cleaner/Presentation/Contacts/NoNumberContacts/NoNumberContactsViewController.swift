//
//  NoNumberContactsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.10.2024.
//

import ContactsUI
import BottomPopup

final class NoNumberContactsViewController: UIViewController {
    @IBOutlet weak var arrowBackButton: UIView!
    @IBOutlet weak var selectionButton: SelectionButtonStyle!
    @IBOutlet weak var unresolvedContactsCount: Regular13LabelStyle!
    @IBOutlet weak var unresolvedContactsTableView: UITableView!
    @IBOutlet weak var toolbar: ActionToolbar!
    
    private var contacts: [CNContact] = [] {
        didSet {
            unresolvedContactsCount.bind(text: "\(contacts.count) contact\(contacts.count == 1 ? "" : "s")")
            selectionButton.isClickable = !contacts.isEmpty
            unresolvedContactsTableView.reloadData()
            if contacts.isEmpty {
                setupEmptyState()
            } else {
                selectionButton.bind(text: contactsForDeletion.count == contacts.count ? .deselectAll : .selectAll)
                toolbar.toolbarButton.bind(text: "Delete")
                toolbar.toolbarButton.isClickable = !contactsForDeletion.isEmpty
                emptyStateView = nil
            }
        }
    }
    
    private var contactsForDeletion = Set<CNContact>() {
        didSet {
            selectionButton.bind(text: contactsForDeletion.count == contacts.count ? .deselectAll : .selectAll)
            toolbar.toolbarButton.bind(text: "Delete\(contactsForDeletion.isEmpty ? "" : " Selected (\(contactsForDeletion.count))")")
            toolbar.toolbarButton.isClickable = !contactsForDeletion.isEmpty
            unresolvedContactsTableView.reloadData()
        }
    }
    
    private lazy var emptyStateView: EmptyStateView? = nil
    
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
    
    @IBAction func tapOnSelectionButton(_ sender: Any) {
        if contactsForDeletion.count == contacts.count {
            contactsForDeletion.removeAll()
        } else {
            contactsForDeletion.insert(contacts)
        }
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
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationController?.pushViewController(contactVC, animated: true)
        }
    }
    
    private func setupEmptyState() {
        selectionButton.bind(text: .selectAll)
        toolbar.toolbarButton.bind(text: "Back")
        toolbar.toolbarButton.isClickable = true
        emptyStateView = view.createEmptyState(type: .noNameContacts)
        if let emptyStateView {
            view.addSubview(emptyStateView)
        }
    }
}

extension NoNumberContactsViewController: ViewControllerProtocol {
    func setupUI() {
        toolbar.delegate = self
    }
    
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
        
        cell.content.backgroundColor = contactsForDeletion.contains(contacts[indexPath.row]) ? .lightBlueBackground : .white
        
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

extension NoNumberContactsViewController: ActionToolbarDelegate, BottomPopupDelegate {
    func tapOnActionButton() {
        if contacts.isEmpty {
            navigationController?.popViewController(animated: true)
        } else {
            guard let vc = UIStoryboard(name: ConfirmActionViewController.idenfifier, bundle: .main).instantiateViewController(identifier: ConfirmActionViewController.idenfifier) as? ConfirmActionViewController else { return }
            vc.popupDelegate = self
            vc.height = 238
            vc.actionButtonText = "Delete Selected (\(contactsForDeletion.count))"
            vc.type = .deleteContacts
            DispatchQueue.main.async { [weak self] in
                self?.present(vc, animated: true)
            }
        }
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        if newValue == 100 {
            ContactManager.delete(Array(contactsForDeletion))
            contactsForDeletion.removeAll()
            reloadData()
        }
    }
}
