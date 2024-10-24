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
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noContactsStackView: UIStackView!
    @IBOutlet weak var checkBoxImage: UIImageView!
    @IBOutlet weak var selectAllStackView: UIStackView!
    @IBOutlet weak var selectedCounterLabel: UILabel!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    
    private var contacts: [CNContact] = [] {
        didSet{
            if contacts.isEmpty {
                noContactsStackView.isHidden = false
                selectView.isHidden = true
            } else {
                noContactsStackView.isHidden = true
                selectView.isHidden = false
            }
        }
    }
    
    private var contactsForDeletion = Set<CNContact>() {
        didSet {
            selectedCounterLabel.text = "Selected: \(contactsForDeletion.count)"
            if contactsForDeletion.count == contacts.count {
                checkBoxImage.image = Asset.selectedCheckBox.image
            } else {
                checkBoxImage.image = Asset.emptyCheckBox.image
            }
            if contactsForDeletion.isEmpty {
                blockView.isHidden = false
                deleteButton.isUserInteractionEnabled = false
            } else {
                blockView.isHidden = true
                deleteButton.isUserInteractionEnabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupUI()
        backView.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        selectAllStackView.addTapGestureRecognizer {
            if self.contactsForDeletion.count != self.contacts.count {
                for cont in self.contacts {
                    if !self.contactsForDeletion.contains(cont) {
                        self.contactsForDeletion.insert(cont)
                    }
                }
            } else {
                self.contactsForDeletion.removeAll()
            }
            self.collectionView.reloadData()
        }
        deleteButton.addTapGestureRecognizer {
            let deleteAlert = UIAlertController(title: "", message: "Contacts will be deleted from your Contacts", preferredStyle: UIAlertController.Style.actionSheet)
            
            let unfollowAction = UIAlertAction(title: "Delete Contacts: \(self.contactsForDeletion.count)", style: .destructive) { (action: UIAlertAction) in
                ContactManager.deleteArray(self.contactsForDeletion)
                self.contacts = self.contacts.filter({ !self.contactsForDeletion.contains($0) })
                self.collectionView.reloadData()
                self.blockView.isHidden = false
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            deleteAlert.addAction(unfollowAction)
            deleteAlert.addAction(cancelAction)
            self.present(deleteAlert, animated: true, completion: nil)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        reloadData()
    }
    
    private func setupUI() {
        
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: IncompleteCell.self)
    }
    
    private func reloadData() {
        ContactManager.loadContacts { contacts in
            self.contacts = contacts.filter { $0.givenName.isEmpty || $0.phoneNumbers.count == 0}
            self.collectionView.reloadData()
        }
    }
    
    private func presentContact(contact: CNContact) {
        do {
            let store = CNContactStore()
            let descriptor = CNContactViewController.descriptorForRequiredKeys()
            let editContact = try store.unifiedContact(withIdentifier: contact.identifier, keysToFetch: [descriptor])
            let contactVC = CNContactViewController(for: editContact)
            contactVC.allowsEditing = true // Set to true if you want to allow editing
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationController?.pushViewController(contactVC, animated: true)
        } catch {
            print(error)
        }
    }
}

extension NoNameContactsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(for: indexPath) as IncompleteCell
        let contact = contacts[indexPath.row]
        if !(contact.givenName.isEmpty && contact.familyName.isEmpty){
            cell.infoLabel.text = contact.givenName + " " + contact.familyName
        } else {
            cell.infoLabel.text = contact.phoneNumbers.first?.value.stringValue
        }
        
        if self.contactsForDeletion.contains(contact) {
            cell.isChecked = true
        } else {
            cell.isChecked = false
        }
        
        cell.cardView.addTapGestureRecognizer {
            self.presentContact(contact: contact)
        }
        
        cell.statusImage.addTapGestureRecognizer {
            if self.contactsForDeletion.contains(contact) {
                self.contactsForDeletion.remove(contact)
            } else {
                self.contactsForDeletion.insert(contact)
            }
            self.collectionView.reloadData()
        }
        
        return cell
    }
}

extension NoNameContactsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
    }
}
//
//extension IncompliteContactsViewController: CNContactPickerDelegate {
//    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
//        reloadData()
//    }
//}
//
