//
//  AllContactsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 06.11.2024.
//

import UIKit
import Contacts

final class AllContactsViewController: UIViewController {
    @IBOutlet weak var arrowBackView: UIView!
    @IBOutlet weak var contactsCountLabel: Regular13LabelStyle!
    @IBOutlet weak var contactsTableView: UITableView!
    
    private lazy var contacts: [CNContactSection] = [] {
        didSet {
            contactsCountLabel.bind(text: "\(contacts.count) contact\(contacts.count == 1 ? "" : "s")")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    private func reloadData() {
        ContactManager.loadAllContacts { contacts in
            self.contacts = contacts
        }
    }
}

extension AllContactsViewController: ViewControllerProtocol {
    func setupUI() {
        contactsTableView.register(cellType: UnresolvedItemCell.self)
    }
    
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension AllContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
