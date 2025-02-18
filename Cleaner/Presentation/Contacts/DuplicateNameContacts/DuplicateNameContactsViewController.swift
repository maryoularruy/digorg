//
//  DuplicateNameContactsViewController.swift
//  Cleaner
//
//  Created by Максим Лебедев on 20.10.2023.
//

import ContactsUI
import BottomPopup

final class DuplicateNameContactsViewController: UIViewController {
    @IBOutlet weak var arrowBackButton: UIView!
    @IBOutlet weak var unresolvedContactsCount: Regular13LabelStyle!
    @IBOutlet weak var unresolvedContactsTableView: UITableView!
    @IBOutlet weak var selectionButton: SelectionButtonStyle!
    @IBOutlet weak var toolbar: ActionAndCancelToolbar!
    @IBOutlet weak var emptyStateToolbar: ActionToolbar!
    
    private lazy var contactManager = ContactManager.shared
    
    private lazy var contactGroups = [[CNContact]]() {
        didSet {
            selectionButton.isClickable = !contactGroups.isEmpty
            unresolvedContactsCount.text = "\(contactGroups.count) contact\(contactGroups.count == 1 ? "" : "s")"
            if contactGroups.isEmpty {
                setupEmptyState()
            } else {
                selectionButton.bind(text: contactGroups.count == contactsForMerge.count ? .deselectAll : .selectAll)
                emptyStateView = nil
            }
        }
    }
    
    private lazy var contactsForMerge = [Int: [CNContact]]() {
        didSet {
            selectionButton.bind(text: contactGroups.count == contactsForMerge.count ? .deselectAll : .selectAll)
            unresolvedContactsCount.text = "\(contactGroups.count) contact\(contactGroups.count == 1 ? "" : "s")"
            toolbar.isHidden = contactsForMerge.isEmpty || contactsForMergeCount == 1
            toolbar.actionButton.bind(text: "Merge Contacts (\(readyContactsForMergeCount))")
        }
    }
    
    private var contactsForMergeCount: Int {
        contactsForMerge.reduce(0) { $0 + $1.value.count }
    }
    
    private var readyContactsForMergeCount: Int {
        var count: Int = 0
        contactsForMerge.values.forEach { value in
            if value.count >= 2 {
                count += 1
            }
        }
        return count
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
        refreshData()
        setupUnresolvedContactsTableView()
    }

    private func setupUnresolvedContactsTableView() {
        unresolvedContactsCount.bind(text: "\(contactGroups.count) contact\(contactGroups.count == 1 ? "" : "s")")
    }
    
    private func refreshData() {
        contactManager.loadDuplicatedByName { [weak self] duplicateGroups in
            self?.contactGroups = duplicateGroups
        }
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

extension DuplicateNameContactsViewController: ViewControllerProtocol {
    func setupUI() {
        unresolvedContactsTableView.register(cellType: DuplicateNamesTableViewCell.self)
        unresolvedContactsTableView.contentInset.bottom = 160
        selectionButton.delegate = self
        toolbar.delegate = self
    }
    
    func addGestureRecognizers() {
        arrowBackButton.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }
}

extension DuplicateNameContactsViewController: SelectionButtonDelegate {
    func tapOnButton() {
        if contactsForMerge.count == contactGroups.count {
            contactsForMerge.removeAll()
        } else {
            contactsForMerge.removeAll()
            for i in 0..<contactGroups.count {
                contactsForMerge[i] = contactGroups[i]
            }
        }
        unresolvedContactsTableView.reloadData()
    }
}

extension DuplicateNameContactsViewController: ActionAndCancelToolbarDelegate, BottomPopupDelegate {
    func tapOnAction() {
        guard let vc = UIStoryboard(name: ConfirmActionViewController.idenfifier, bundle: .main).instantiateViewController(identifier: ConfirmActionViewController.idenfifier) as? ConfirmActionViewController else { return }
        vc.popupDelegate = self
        vc.height = 238
        vc.actionButtonText = "Merge Contacts (\(contactGroups.count))"
        vc.type = .mergeContacts
        DispatchQueue.main.async { [weak self] in
            self?.present(vc, animated: true)
        }
    }
    
    func tapOnCancel() {
        contactsForMerge.removeAll()
        unresolvedContactsTableView.reloadData()
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        if newValue == 100 {
            contactsForMerge.forEach { contactManager.merge($0.value) { [weak self] result in
                guard let self else { return }
                switch result {
                case true:
                    let successView = SuccessView(frame: SuccessView.myFrame)
                    successView.bind(type: .successMerge)
                    successView.center = view.center
                    view.addSubview(successView)
                    successView.setHidden {
                        successView.removeFromSuperview()
                        DispatchQueue.global(qos: .userInitiated).sync { [weak self] in
                            guard let self else { return }
                            refreshData()
                            setupUnresolvedContactsTableView()
                            toolbar.isHidden = true
                            unresolvedContactsTableView.reloadData()
                        }
                    }
                case false: break
                }
            }}
        }
    }
}

extension DuplicateNameContactsViewController: ActionToolbarDelegate {
    func tapOnActionButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupEmptyState() {
        selectionButton.bind(text: .selectAll)
        emptyStateView = view.createEmptyState(type: .noDuplicateNames)
        if let emptyStateView {
            view.addSubview(emptyStateView)
        }
        emptyStateToolbar.toolbarButton.bind(text: "Back")
        emptyStateToolbar.delegate = self
        emptyStateToolbar.isHidden = false
    }
}

extension DuplicateNameContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DuplicateNamesTableViewCell.identifier, for: indexPath) as! DuplicateNamesTableViewCell
        cell.delegate = self
        cell.bind(contactGroups[indexPath.row],
                  type: .duplicateNames,
                  position: indexPath.row,
                  contactsForMerge: contactsForMerge[indexPath.row] ?? [])
        return cell
    }
}

extension DuplicateNameContactsViewController: DuplicateNamesTableViewCellDelegate {
    func tapOnSelectButton(row: Int) {
        if let contacts = contactsForMerge[row] {
            if contacts.count == contactGroups[row].count {
                contactsForMerge.removeValue(forKey: row)
            } else {
                contactsForMerge[row] = contactGroups[row]
            }
        } else {
            contactsForMerge[row] = contactGroups[row]
        }
        unresolvedContactsTableView.reloadData()
    }
    
    func tapOnCheckBox(selectedContacts: [CNContact], row: Int) {
        if let contactsForMergeByRow = contactsForMerge[row] {
            if contactsForMerge[row]?.count == selectedContacts.count && selectedContacts.count == 2 {
                contactsForMerge.removeValue(forKey: row)
            } else {
                selectedContacts.forEach { contact in
                    if contactsForMergeByRow.contains(contact) {
                        if contactsForMerge[row]?.count == 1 {
                            contactsForMerge.removeValue(forKey: row)
                        } else {
                            contactsForMerge[row]?.removeAll { $0.identifier == contact.identifier }
                        }
                    } else {
                        contactsForMerge[row]?.append(contact)
                    }
                }
            }
        } else {
            contactsForMerge[row] = selectedContacts
        }
        unresolvedContactsTableView.reloadData()
    }
    
    func tapOnCell(contact: CNContact) {
        presentContact(contact: contact)
    }
}
