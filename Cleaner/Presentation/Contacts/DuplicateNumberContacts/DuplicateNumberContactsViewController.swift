//
//  DuplicateNumberContactsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.12.2024.
//

import UIKit
import Contacts

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
                rootView.selectionButton.bind(text: contactGroups.count == contactsForMerge.count ? .deselectAll : .selectAll)
                emptyStateView = nil
            }
        }
    }
    
    private var contactsCount: Int {
        contactGroups.reduce(0) { $0 + $1.count }
    }
    
    private lazy var contactsForMerge = Set<[CNContact]>() {
        didSet {
            rootView.duplicatesCountLabel.bind(text: "\(contactGroups.count) contact\(contactGroups.count == 1 ? "" : "s")")
            rootView.selectionButton.bind(text: contactGroups.count == contactsForMerge.count ? .deselectAll : .selectAll)
            rootView.duplicatesTableView.reloadData()
        }
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
    
    deinit {
        print("deinit dup numbers")
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
        if contactsForMerge.count == contactGroups.count {
            contactsForMerge.removeAll()
        } else {
            contactsForMerge.insert(contactGroups)
        }
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
    func tapOnSelectButton(rowPosition: Int) {
        if contactsForMerge.contains(contactGroups[rowPosition]) {
            contactsForMerge.remove(contactGroups[rowPosition])
        } else {
            contactsForMerge.insert(contactGroups[rowPosition])
        }
    }
}

extension DuplicateNumberContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DuplicatesTableViewCell.identifier, for: indexPath) as! DuplicatesTableViewCell
        cell.delegate = self
        cell.isUserInteractionEnabled = true
        cell.bind(contactGroups[indexPath.row], position: indexPath.row)
        cell.selectionButton.bind(text: contactsForMerge.contains(contactGroups[indexPath.row]) ? .deselectAll : .selectAll)
        return cell
    }
}
