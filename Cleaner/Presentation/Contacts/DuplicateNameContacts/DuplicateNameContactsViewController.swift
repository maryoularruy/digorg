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
            if sections.isEmpty { setupEmptyState() }
            else { hideEmptyState() }
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
    
    @IBAction func tapOnSelectAllButton(_ sender: Any) {
        selectMode.toggle()
    }
    
    private func setupUnresolvedContactsTableView() {
        unresolvedContactsCount.bind(text: "\(sections.count) contact\(sections.count == 1 ? "" : "s")")
        unresolvedContactsTableView.register(cellType: UnresolvedItemCell.self)
    }
    
    private func reloadData() {
        ContactManager.loadDuplicatedByName { [weak self] duplicateGroups in
            self?.sections = duplicateGroups
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
}

extension DuplicateNameContactsViewController: UITableViewDelegate, UITableViewDataSource {
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
        86
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UnresolvedItemCellHeader()
        header.firstLabel.bind(text: "\(sections[section].count) duplicates")
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        34
    }
}

extension DuplicateNameContactsViewController: UnresolvedItemCellProtocol {
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
        presentContact(contact: sections[position.0][position.1])
    }
}

extension DuplicateNameContactsViewController: ViewControllerProtocol {
    func setupUI() {
        toolbar.delegate = self
    }
    
    func addGestureRecognizers() {
        arrowBackButton.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension DuplicateNameContactsViewController: ActionAndCancelToolbarDelegate, BottomPopupDelegate {
    func tapOnAction() {
        guard let vc = UIStoryboard(name: ConfirmActionViewController.idenfifier, bundle: .main).instantiateViewController(identifier: ConfirmActionViewController.idenfifier) as? ConfirmActionViewController else { return }
        vc.popupDelegate = self
        vc.height = 238
        vc.actionButtonText = "Merge Contacts (\(sections.count))"
        vc.type = .mergeContacts
        DispatchQueue.main.async { [weak self] in
            self?.present(vc, animated: true)
        }
    }
    
    func tapOnCancel() {
        selectMode = false
        reloadData()
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        if newValue == 100 {
            contactsForMerge.forEach { ContactManager.merge($0) { [weak self] result in
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
                        reloadData()
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
