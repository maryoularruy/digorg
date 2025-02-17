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
    private lazy var contactManager = ContactManager.shared
    private lazy var folderName = userDefaultsService.get(String.self, key: .secretAlbumFolder) ?? "media"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUI()
    }
    
    @IBAction func tapOnAddButton(_ sender: Any) {
        if userDefaultsService.isPasscodeCreated {
            if userDefaultsService.isPasscodeConfirmed {
                let vc = StoryboardScene.AllContacts.initialScene.instantiate()
                vc.modalPresentationStyle = .overCurrentContext
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = StoryboardScene.Passcode.initialScene.instantiate()
                vc.assetsIsParentVC = false
                vc.passcodeMode = .enter
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let vc = StoryboardScene.Passcode.initialScene.instantiate()
            vc.passcodeMode = .create
            vc.assetsIsParentVC = false
            vc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func tapOnSelectionButton(_ sender: Any) {
        if contactsForDeletion.count == contacts.count {
            contactsForDeletion.removeAll()
        } else {
            contactsForDeletion.insert(contacts)
        }
    }
    
    private func updateUI() {
        lockedStatusIcon.image = userDefaultsService.isPasscodeCreated && userDefaultsService.isPasscodeTurnOn ? .locked :  .unlocked
        
        if userDefaultsService.isPasscodeTurnOn {
            if userDefaultsService.isPasscodeConfirmed {
                reloadData()
            } else {
                showSecretAlbumCover()
            }
        } else {
            reloadData()
        }
    }
    
    private func reloadData() {
        contacts = contactManager.getSecretContacts() ?? []
    }
    
    private func showSecretAlbumCover() {
        contactsTableView.isHidden = true
        itemsCountLabel.bind(text: "0 contacts")
        selectionButton.isHidden = true
    }
    
    private func setupEmptyState() {
        contactsTableView.isHidden = true
        itemsCountLabel.bind(text: "0 contacts")
        selectionButton.isHidden = true
        
        emptyStateView?.removeFromSuperview()
        emptyStateView = view.createEmptyState(type: .emptySecretContacts)
        if let emptyStateView {
            view.addSubview(emptyStateView)
        }
    }
    
    private func hideEmptyState() {
        contactsTableView.isHidden = false
        contactsTableView.reloadData()
        
        selectionButton.isHidden = false
        selectionButton.bind(text: contactsForDeletion.count == contacts.count ? .deselectAll : .selectAll)
        
        addButton.isHidden = false
        
        emptyStateView?.removeFromSuperview()
        emptyStateView = nil
    }
}

extension SecretContactsViewController: ViewControllerProtocol {
    func setupUI() {
        contactsTableView.register(cellType: ItemCell.self)
    }
    
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }
}

extension SecretContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as ItemCell
        cell.delegate = self
        cell.setupSingleCellInSection()
        cell.bind(contact: contacts[indexPath.row], indexPath.row)
        
        cell.checkBoxButton.image = contactsForDeletion.contains(contacts[indexPath.row]) ? .selectedCheckBoxBlue : .emptyCheckBoxBlue
        
        cell.content.backgroundColor = contactsForDeletion.contains(contacts[indexPath.row]) ? .lightBlue : .paleGrey
        
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
