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
    
    private lazy var contacts: [CNContact] = [] {
        didSet {
            itemsCountLabel.bind(text: "\(contacts.count) contact\(contacts.count == 1 ? "" : "s")")
//            itemsCollectionView.reloadData()
//            if items.isEmpty {
//                setupEmptyState()
//            } else {
//                hideEmptyState()
//            }
        }
    }
    
    private lazy var userDefaultsService = UserDefaultsService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupUI()
//        reloadData()
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
