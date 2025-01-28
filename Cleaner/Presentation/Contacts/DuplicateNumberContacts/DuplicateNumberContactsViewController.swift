//
//  DuplicateNumberContactsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.12.2024.
//

import UIKit
import ContactsUI
import BottomPopup

final class DuplicateNumberContactsViewController: UIViewController {
    private var rootView = DuplicateNumberContactsView()
    
    private lazy var contactManager = ContactManager.shared
    
    private lazy var contactGroups = [[CNContact]]() {
        didSet {
            rootView.duplicatesCountLabel.bind(text: "\(contactGroups.count) contact\(contactGroups.count == 1 ? "" : "s")")
            rootView.selectionButton.isClickable = !contactGroups.isEmpty
            rootView.toolbar.isHidden = !contactGroups.isEmpty
            if contactGroups.isEmpty {
                setupEmptyState()
            } else {
                rootView.selectionButton.bind(text: contactsCount == contactsForMergeCount ? .deselectAll : .selectAll)
                emptyStateView = nil
            }
        }
    }
    
    private var contactsCount: Int {
        contactGroups.reduce(0) { $0 + $1.count }
    }
    
    private lazy var contactsForMerge = [Int: [CNContact]]() {
        didSet {
            rootView.duplicatesCountLabel.bind(text: "\(contactGroups.count) contact\(contactGroups.count == 1 ? "" : "s")")
            rootView.selectionButton.bind(text: contactsCount == contactsForMergeCount ? .deselectAll : .selectAll)
        }
    }
    
    private var contactsForMergeCount: Int {
        contactsForMerge.reduce(0) { $0 + $1.value.count }
    }
    
    private lazy var emptyStateView: EmptyStateView? = nil
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.selectionButton.delegate = self
        rootView.duplicatesTableView.dataSource = self
        rootView.duplicatesTableView.delegate = self
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupUI()
        rootView.duplicatesTableView.register(DuplicatesTableViewCell.self, forCellReuseIdentifier: DuplicatesTableViewCell.identifier)
    }
    
    private func setupEmptyState() {
        rootView.selectionButton.bind(text: .selectAll)
        rootView.toolbar.toolbarButton.bind(text: "Back")
        rootView.toolbar.delegate = self
        emptyStateView = view.createEmptyState(type: .noDuplicateNumbers)
        if let emptyStateView {
            view.addSubview(emptyStateView)
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

extension DuplicateNumberContactsViewController: ViewControllerProtocol {
    func setupUI() {
        contactManager.loadDuplicatedByNumber { [weak self] contactGroups in
            self?.contactGroups = contactGroups
        }
    }
    
    func addGestureRecognizers() {
        rootView.arrowBack.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }
}

extension DuplicateNumberContactsViewController: SelectionButtonDelegate {
    func tapOnButton() {
        if contactsCount == contactsForMergeCount {
            contactsForMerge.removeAll()
        } else {
            contactsForMerge.removeAll()
            for i in 0..<contactGroups.count {
                contactsForMerge[i] = contactGroups[i]
            }
        }
        rootView.duplicatesTableView.reloadData()
    }
}

extension DuplicateNumberContactsViewController: ActionToolbarDelegate {
    func tapOnActionButton() {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension DuplicateNumberContactsViewController: DuplicatesTableViewCellDelegate {
    func tapOnCheckBox(selectedContacts: [CNContact], row: Int) {
        if let contactsForMergeByRow = contactsForMerge[row] {
            if contactsForMerge[row]?.count == selectedContacts.count && selectedContacts.count == 2 {
                contactsForMerge[row]?.removeAll()
            } else {
                selectedContacts.forEach { contact in
                    if contactsForMergeByRow.contains(contact) {
                        contactsForMerge[row]?.removeAll { $0.identifier == contact.identifier }
                    } else {
                        contactsForMerge[row]?.append(contact)
                    }
                }
            }
        } else {
            contactsForMerge[row] = selectedContacts
        }
        rootView.duplicatesTableView.reloadData()
    }
    
    func tapOnCell(contact: CNContact) {
        presentContact(contact: contact)
    }
    
    func tapOnSelectButton(row: Int) {
        if let contacts = contactsForMerge[row] {
            if contacts.count == contactGroups[row].count {
                contactsForMerge[row]?.removeAll()
            } else {
                contactsForMerge[row] = contactGroups[row]
            }
        } else {
            contactsForMerge[row] = contactGroups[row]
        }
        rootView.duplicatesTableView.reloadData()
    }
    
    func tapOnMergeContacts(contactsForMerge: [CNContact], row: Int) {
        guard let vc = UIStoryboard(name: SelectedContactsBottomPopupViewController.idenfifier, bundle: .main).instantiateViewController(identifier: SelectedContactsBottomPopupViewController.idenfifier) as? SelectedContactsBottomPopupViewController else { return }
        vc.delegate = self
        vc.type = .mergeContacts
        vc.contacts = contactsForMerge
        vc.position = row
        vc.calcPopupHeight()
        DispatchQueue.main.async { [weak self] in
            self?.present(vc, animated: true)
        }
    }
}

extension DuplicateNumberContactsViewController: SelectedContactsBottomPopupViewControllerDelegate {
    func tapOnMerge(activeChoice: Int, row: Int) {
        contactManager.merge(contactsForMerge[row] ?? [], userChoice: activeChoice) { [weak self] result in
            guard let self else { return }
            switch result {
            case true:
                let successView = SuccessView(frame: SuccessView.myFrame)
                successView.bind(type: .successMerge)
                successView.center = view.center
                view.addSubview(successView)
                successView.setHidden {
                    successView.removeFromSuperview()
                }
                DispatchQueue.global(qos: .userInitiated).sync { [weak self] in
                    guard let self else { return }
                    setupUI()
                    rootView.duplicatesTableView.reloadData()
                }
            case false: break
            }
        }
    }
}

extension DuplicateNumberContactsViewController: BottomPopupDelegate {
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        
    }
}

extension DuplicateNumberContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DuplicatesTableViewCell.identifier, for: indexPath) as! DuplicatesTableViewCell
        cell.delegate = self
        cell.bind(contactGroups[indexPath.row], position: indexPath.row, contactsForMerge: contactsForMerge[indexPath.row] ?? [])
        return cell
    }
}
