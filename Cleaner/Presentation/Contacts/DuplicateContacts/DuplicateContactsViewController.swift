//
//  DuplicateContactsViewController.swift
//  Cleaner
//
//  Created by Максим Лебедев on 20.10.2023.
//

import UIKit
import Contacts
import ContactsUI

class DuplicateContactsViewController: UIViewController {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var checkBoxImage: UIImageView!
    @IBOutlet weak var selectAllStackView: UIStackView!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var selectedCounterLabel: UILabel!
    @IBOutlet weak var noContactsStackView: UIStackView!
    
    private var sections = [[CNContact]]() {
        didSet{
            if sections.isEmpty {
                noContactsStackView.isHidden = false
                selectView.isHidden = true
            } else {
                noContactsStackView.isHidden = true
                selectView.isHidden = false
            }
        }
    }
    
    private var contactsForMerge = Set<[CNContact]>() {
        didSet {
            selectedCounterLabel.text = "Selected: \(contactsForMerge.count)"
            if contactsForMerge == Set(sections) {
                checkBoxImage.image = Asset.selectedCheckBox.image
            } else {
                checkBoxImage.image = Asset.emptyCheckBox.image
            }
            if contactsForMerge.isEmpty {
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
        reloadData()
        setupCollectionView()
        setupActions()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: MergeSectionCell.self)
    }
    
    private func reloadData() {
        ContactManager.loadContacts({ contacts in
            self.sections = ContactManager.findDuplicateContacts(contacts: contacts)
//            print("SECTIO",self.contacts)
//            self.contacts = [contacts[5], contacts[6], contacts[7]]
            self.collectionView.reloadData()
        })
    }
    
    private func setupActions() {
        backView.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        selectAllStackView.addTapGestureRecognizer {
            
            self.collectionView.reloadData()
        }
    }
    
    private func presentContact(contact: CNContact) {
        do {
            let store = CNContactStore()
            let descriptor = CNContactViewController.descriptorForRequiredKeys()
            let editContact = try store.unifiedContact(withIdentifier: contact.identifier, keysToFetch: [descriptor])
            let contactVC = CNContactViewController(for: editContact)
            contactVC.allowsEditing = true
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationController?.pushViewController(contactVC, animated: true)
        } catch {
            print(error)
        }
    }
}

extension DuplicateContactsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(for: indexPath) as MergeSectionCell
        cell.setupData(data: sections[indexPath.row])
        return cell
    }
}

extension DuplicateContactsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = 0.0
        if sections[indexPath.row].count < 3 {
            height = 350
        } else {
            height = 440
        }
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
    }
}
