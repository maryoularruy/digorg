//
//  NoNumberContactsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.10.2024.
//

import UIKit
import Contacts

final class NoNumberContactsViewController: UIViewController {
    @IBOutlet weak var arrowBackButton: UIView!
    @IBOutlet weak var unresolvedContactsCount: Regular13LabelStyle!
    
    private var contacts: [CNContact] = [] {
        didSet {
            unresolvedContactsCount.bind(text: "\(contacts.count) contact\(contacts.count == 1 ? "" : "s")")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    private func reloadData() {
        ContactManager.loadIncompletedByName { contacts in
            self.contacts = contacts
        }
    }
}

extension NoNumberContactsViewController: ViewControllerProtocol {
    func setupUI() {}
    
    func addGestureRecognizers() {
        arrowBackButton.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
