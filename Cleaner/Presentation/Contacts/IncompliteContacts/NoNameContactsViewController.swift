//
//  IncompliteContactsViewController.swift
//  Cleaner
//
//  Created by Максим Лебедев on 20.10.2023.
//

import UIKit
import Contacts
import ContactsUI

class NoNameContactsViewController: UIViewController {
    @IBOutlet weak var arrowBackButton: UIView!
    @IBOutlet weak var unresolvedContactsCount: Regular13LabelStyle!
    @IBOutlet weak var unresolvedContactsTableView: UITableView!
    //    @IBOutlet weak var backView: UIView!
    //    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var noContactsStackView: UIStackView!
//    @IBOutlet weak var checkBoxImage: UIImageView!
//    @IBOutlet weak var selectAllStackView: UIStackView!
//    @IBOutlet weak var selectedCounterLabel: UILabel!
//    @IBOutlet weak var selectView: UIView!
//    @IBOutlet weak var blockView: UIView!
//    @IBOutlet weak var deleteButton: UIButton!
    
    private var contacts: [CNContact] = [] {
        didSet {
            unresolvedContactsCount.bind(text: "\(contacts.count) contact\(contacts.count == 1 ? "" : "s")")
            unresolvedContactsTableView.reloadData()
            if contacts.isEmpty {
//                noContactsStackView.isHidden = false
//                selectView.isHidden = true
            } else {
//                noContactsStackView.isHidden = true
//                selectView.isHidden = false
            }
        }
    }
    
    private var contactsForDeletion = Set<CNContact>() {
        didSet {
            unresolvedContactsTableView.reloadData()
//            selectedCounterLabel.text = "Selected: \(contactsForDeletion.count)"
//            if contactsForDeletion.count == contacts.count {
//                checkBoxImage.image = Asset.selectedCheckBox.image
//            } else {
//                checkBoxImage.image = Asset.emptyCheckBox.image
//            }
//            if contactsForDeletion.isEmpty {
//                blockView.isHidden = false
//                deleteButton.isUserInteractionEnabled = false
//            } else {
//                blockView.isHidden = true
//                deleteButton.isUserInteractionEnabled = true
//            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
//        backView.addTapGestureRecognizer {
//            self.navigationController?.popViewController(animated: true)
//        }
//        selectAllStackView.addTapGestureRecognizer {
//            if self.contactsForDeletion.count != self.contacts.count {
//                for cont in self.contacts {
//                    if !self.contactsForDeletion.contains(cont) {
//                        self.contactsForDeletion.insert(cont)
//                    }
//                }
//            } else {
//                self.contactsForDeletion.removeAll()
//            }
//            self.collectionView.reloadData()
//        }
//        deleteButton.addTapGestureRecognizer {
//            let deleteAlert = UIAlertController(title: "", message: "Contacts will be deleted from your Contacts", preferredStyle: UIAlertController.Style.actionSheet)
//            
//            let unfollowAction = UIAlertAction(title: "Delete Contacts: \(self.contactsForDeletion.count)", style: .destructive) { (action: UIAlertAction) in
//                ContactManager.deleteArray(self.contactsForDeletion)
//                self.contacts = self.contacts.filter({ !self.contactsForDeletion.contains($0) })
//                self.collectionView.reloadData()
//                self.blockView.isHidden = false
//            }
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            
//            deleteAlert.addAction(unfollowAction)
//            deleteAlert.addAction(cancelAction)
//            self.present(deleteAlert, animated: true, completion: nil)
//            
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        reloadData()
        setupUnresolvedContactsTableView()
    }
    
    private func setupUnresolvedContactsTableView() {
        unresolvedContactsTableView.register(cellType: UnresolvedItemCell.self)
    }
    
    private func reloadData() {
        ContactManager.loadContacts { contacts in
            self.contacts = contacts.filter { $0.givenName.isEmpty || $0.phoneNumbers.count == 0 }
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

extension NoNameContactsViewController: ViewControllerProtocol {
    func setupUI() {
         
    }
    
    func addGestureRecognizers() {
        arrowBackButton.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension NoNameContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as UnresolvedItemCell
        cell.delegate = self
        cell.bind(contact: contacts[indexPath.row], indexPath.row)
        
        cell.checkBoxButton.image = contactsForDeletion.contains(contacts[indexPath.row]) ? .selectedCheckBoxBlue : .emptyCheckBoxBlue
        
        cell.setupCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //72 height of the cell + 8 top&bottom insets
        88
    }
}

extension NoNameContactsViewController: UnresolvedItemCellProtocol {
    func tapOnCheckBox(_ position: (Int, Int)) {
        let contact = contacts[position.1]
        if contactsForDeletion.contains(contact) {
            contactsForDeletion.remove(contact)
        } else {
            contactsForDeletion.insert(contact)
        }
        
//        if contactsForMerge.count == sections.count {
//            tapOnSelectAllButton(self)
//        }
    }
    
    func tapOnCell(_ position: (Int, Int)) {
        presentContact(contact: contacts[position.1])
    }
}

//extension NoNameContactsViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = self.collectionView.dequeueReusableCell(for: indexPath) as IncompleteCell
//        let contact = contacts[indexPath.row]
//        if !(contact.givenName.isEmpty && contact.familyName.isEmpty){
//            cell.infoLabel.text = contact.givenName + " " + contact.familyName
//        } else {
//            cell.infoLabel.text = contact.phoneNumbers.first?.value.stringValue
//        }
//        
//        if self.contactsForDeletion.contains(contact) {
//            cell.isChecked = true
//        } else {
//            cell.isChecked = false
//        }
//        
//        cell.cardView.addTapGestureRecognizer {
//            self.presentContact(contact: contact)
//        }
//        
//        cell.statusImage.addTapGestureRecognizer {
//            if self.contactsForDeletion.contains(contact) {
//                self.contactsForDeletion.remove(contact)
//            } else {
//                self.contactsForDeletion.insert(contact)
//            }
//            self.collectionView.reloadData()
//        }
//        
//        return cell
//    }
//}
