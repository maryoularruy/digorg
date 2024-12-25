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
            rootView.duplicatesCountLabel.bind(text: "\(contactGroups) contact\(contactGroups.count == 1 ? "" : "s")")
            rootView.selectionButton.bind(text: contactGroups.count == contactsForMerge.count ? .deselectAll : .selectAll)
//            toolbar.isHidden = contactsForMerge.isEmpty
//            toolbar.actionButton.bind(text: "Merge Contacts (\(contactsForMerge.count))")
        }
    }
    
    private lazy var emptyStateView: EmptyStateView? = nil
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.scrollView.frame = view.bounds
        rootView.selectionButton.delegate = self
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    private func setupEmptyState() {
        rootView.selectionButton.bind(text: .selectAll)
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
        
        rootView.scrollView.refreshControl?.addTarget(self, action: #selector(refreshUI), for: .valueChanged)
    }
    
    @objc func refreshUI() {
        setupUI()
        rootView.scrollView.refreshControl?.endRefreshing()
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
