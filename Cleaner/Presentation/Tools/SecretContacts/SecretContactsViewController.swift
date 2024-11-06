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
    
    private lazy var contacts: [CNContact] = [] {
        didSet {
            itemsCountLabel.bind(text: "\(contacts.count) contact\(contacts.count == 1 ? "" : "s")")
            if contacts.isEmpty {
                setupEmptyState()
            } else {
                hideEmptyState()
            }
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
        contacts = []
//        reloadData()
    }
    
    @IBAction func tapOnAddButton(_ sender: Any) {
        
    }
    
    private func setupEmptyState() {
//        itemsCountLabel.bind(text: "0 contacts")
        emptyStateView?.removeFromSuperview()
        emptyStateView = view.createEmptyState(type: .emptySecretContacts)
        if let emptyStateView {
            view.addSubview(emptyStateView)
        }
    }
    
    private func hideEmptyState() {
//        itemsCollectionView.reloadData()
//        itemsCollectionView.isHidden = false
        emptyStateView?.removeFromSuperview()
        emptyStateView = nil
    }
}

extension SecretContactsViewController: ViewControllerProtocol {
    func setupUI() {
        lockedStatusIcon.image = userDefaultsService.isPasscodeCreated ? .locked :  .unlocked
    }
    
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
