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
    @IBOutlet weak var arrowBackButton: UIView!
    @IBOutlet weak var unresolvedContactsCount: Regular13LabelStyle!
    @IBOutlet weak var unresolvedContactsTableView: UITableView!
    @IBOutlet weak var selectionButton: SelectionButtonStyle!
    //    @IBOutlet weak var blockView: UIView!
//    @IBOutlet weak var deleteButton: UIButton!
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var checkBoxImage: UIImageView!
//    @IBOutlet weak var selectAllStackView: UIStackView!
//    @IBOutlet weak var selectView: UIView!
//    @IBOutlet weak var selectedCounterLabel: UILabel!
//    @IBOutlet weak var noContactsStackView: UIStackView!
    
    private lazy var selectMode = false {
        didSet {
            if selectMode {
                selectionButton.bind(text: .deselectAll)
            } else {
                selectionButton.bind(text: .selectAll)
//                assetsForDeletion.removeAll()
                unresolvedContactsTableView.reloadData()
            }
        }
    }
    
    private lazy var sections = [[CNContact]]() {
        didSet {
            if sections.isEmpty {
//                noContactsStackView.isHidden = false
//                selectView.isHidden = true
            } else {
//                noContactsStackView.isHidden = true
//                selectView.isHidden = false
            }
        }
    }
    
    private lazy var contactsForMerge = Set<[CNContact]>() {
        didSet {
//            selectedCounterLabel.text = "Selected: \(contactsForMerge.count)"
            if contactsForMerge == Set(sections) {
//                checkBoxImage.image = Asset.selectedCheckBox.image
            } else {
//                checkBoxImage.image = Asset.emptyCheckBox.image
            }
            if contactsForMerge.isEmpty {
//                blockView.isHidden = false
//                deleteButton.isUserInteractionEnabled = false
            } else {
//                blockView.isHidden = true
//                deleteButton.isUserInteractionEnabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
        
        reloadData()
//        setupCollectionView()
        setupUnresolvedContactsTableView()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        reloadData()
    }
    
    @IBAction func tapOnSelectAllButton(_ sender: Any) {
        selectMode.toggle()
    }
    
    private func setupUnresolvedContactsTableView() {
        unresolvedContactsCount.bind(text: "? contacts")
        unresolvedContactsTableView.register(cellType: UnresolvedItemCell.self)
    }
    
    private func setupCollectionView() {
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(cellType: MergeSectionCell.self)
    }
    
    private func reloadData() {
        ContactManager.loadContacts { [weak self] contacts in
            self?.sections = ContactManager.findDuplicateContacts(contacts: contacts)
//            print("SECTIO",self.contacts)
//            self.contacts = [contacts[5], contacts[6], contacts[7]]
//            self.collectionView.reloadData()
        }
    }
    
    private func setupActions() {
//        selectAllStackView.addTapGestureRecognizer {
//            
//            self.collectionView.reloadData()
//        }
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

extension DuplicateContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections.reduce(0) { $0 + $1.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as UnresolvedItemCell
        cell.delegate = self
        cell.bind(contact: sections[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UnresolvedItemCellHeader()
        header.unresolvedItemsInSection.bind(text: "pnetiayk")
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        34
    }
}

extension DuplicateContactsViewController: UnresolvedItemCellProtocol {
    func tapOnCheckBox() {
        
    }
    
    func tapOnCell() {
        
    }
}

extension DuplicateContactsViewController: ViewControllerProtocol {
    func setupUI() {}
    
    func addGestureRecognizers() {
        arrowBackButton.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

//extension DuplicateContactsViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return sections.count
//    }
//    
////    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//////        let cell = self.collectionView.dequeueReusableCell(for: indexPath) as MergeSectionCell
//////        cell.setupData(data: sections[indexPath.row])
//////        return cell
////    }
//}
//
//extension DuplicateContactsViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var height = 0.0
//        if sections[indexPath.row].count < 3 {
//            height = 350
//        } else {
//            height = 440
//        }
//        return CGSize(width: collectionView.frame.width, height: height)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 16
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
//        
//    }
//}
