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
            selectionButton.bind(text: contactGroups.count == contactsForMerge.count ? .deselectAll : .selectAll)
            if contactGroups.isEmpty {
                setupEmptyState()
            } else {
                hideEmptyState()
            }
        }
    }
    
    private lazy var contactsForMerge = Set<[CNContact]>() {
        didSet {
            selectionButton.bind(text: contactGroups.count == contactsForMerge.count ? .deselectAll : .selectAll)
            unresolvedContactsCount.text = "\(contactGroups.count) contact\(contactGroups.count == 1 ? "" : "s")"
            unresolvedContactsTableView.reloadData()
            toolbar.isHidden = contactsForMerge.isEmpty
            toolbar.actionButton.bind(text: "Merge Contacts (\(contactsForMerge.count))")
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
        refreshData()
        setupUnresolvedContactsTableView()
    }

    private func setupUnresolvedContactsTableView() {
        unresolvedContactsCount.bind(text: "\(contactGroups.count) contact\(contactGroups.count == 1 ? "" : "s")")
        unresolvedContactsTableView.register(cellType: ItemCell.self)
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
    
    deinit {
        print("deinit dup names")
    }
}

extension DuplicateNameContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactGroups[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as ItemCell
        cell.delegate = self
        if indexPath.row == 0 {
            cell.setupFirstCellInSection()
        } else if indexPath.row == contactGroups[indexPath.section].count - 1 {
            cell.setupLastCellInSection()
        } else {
            cell.setupMiddleCellInSection()
        }
        
        cell.content.backgroundColor = contactsForMerge.contains(contactGroups[indexPath.section]) ? .lightBlue : .clear
        cell.checkBoxButton.image = contactsForMerge.contains(contactGroups[indexPath.section]) ? .selectedCheckBoxBlue : .emptyCheckBoxBlue
        
        cell.bind(contact: contactGroups[indexPath.section][indexPath.row], (indexPath.section, indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        86
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        contactGroups.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ItemCellHeader()
        header.delegate = self
        header.bind(section: section)
        header.firstLabel.bind(text: "\(contactGroups[section].count) duplicates")
        header.selectAllButton.bind(text: contactsForMerge.contains(contactGroups[section]) ? .deselectAll : .selectAll)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        34
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        24
    }
}

extension DuplicateNameContactsViewController: ItemCellProtocol, HeaderSelectAllButtonDelegate {
    func tapOnCheckBox(_ position: (Int, Int)) {
        let duplicateContacts = contactGroups[position.0]
        if contactsForMerge.contains(duplicateContacts) {
            contactsForMerge.remove(duplicateContacts)
        } else {
            contactsForMerge.insert(duplicateContacts)
        }
    }
    
    func tapOnCell(_ position: (Int, Int)) {
        presentContact(contact: contactGroups[position.0][position.1])
    }
    
    func tapOnSelectAllButton(_ section: Int) {
        if contactsForMerge.contains(contactGroups[section]) {
            contactsForMerge.remove(contactGroups[section])
        } else {
            contactsForMerge.insert(contactGroups[section])
        }
    }
}

extension DuplicateNameContactsViewController: ViewControllerProtocol {
    func setupUI() {
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
            contactsForMerge.insert(contactGroups)
        }
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
            contactsForMerge.forEach { contactManager.merge($0) { [weak self] result in
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
                        refreshData()
                        setupUnresolvedContactsTableView()
                        toolbar.isHidden = true
                        unresolvedContactsTableView.reloadData()
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
        selectionButton.isEnabled = false
        emptyStateView = view.createEmptyState(type: .noDuplicateNames)
        if let emptyStateView {
            view.addSubview(emptyStateView)
        }
        emptyStateToolbar.toolbarButton.bind(text: "Back")
        emptyStateToolbar.delegate = self
        emptyStateToolbar.isHidden = false
    }
    
    private func hideEmptyState() {
        selectionButton.isEnabled = true
        emptyStateToolbar.delegate = nil
        emptyStateToolbar.isHidden = true
        emptyStateView = nil
    }
}
