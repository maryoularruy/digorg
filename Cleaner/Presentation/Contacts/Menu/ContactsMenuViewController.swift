//
//  ContactsMenuViewController.swift
//  Cleaner
//
//  Created by Максим Лебедев on 20.10.2023.
//

import UIKit
import Contacts

final class ContactsMenuViewController: UIViewController {
    @IBOutlet var contentSV: UIScrollView!
    @IBOutlet weak var arrowBackView: UIView!
    @IBOutlet weak var unresolvedContactsCount: Regular13LabelStyle!
    @IBOutlet weak var duplicateNamesView: ContactsMenuView!
    @IBOutlet weak var duplicateNumbersView: ContactsMenuView!
    @IBOutlet weak var noNameView: ContactsMenuView!
    @IBOutlet weak var noNumberView: ContactsMenuView!
    
    private lazy var contactStore = CNContactStore()
    private lazy var contactManager = ContactManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentSV.frame = view.bounds
        contentSV.alwaysBounceVertical = true
        
        duplicateNamesView.bind(type: .duplicateNames)
        duplicateNumbersView.bind(type: .dublicateNumbers)
        noNameView.bind(type: .noNameContacts)
        noNumberView.bind(type: .noNumberContacts)
        
        [duplicateNamesView, duplicateNumbersView,
         noNameView, noNumberView].forEach { $0.delegate = self }
        
        checkPermissionStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    private func checkAccessStatus() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { [weak self] (granted, error) in
            guard let self else { return }
            if granted {
                DispatchQueue.main.async {
                    let vc = StoryboardScene.ContactsMenu.initialScene.instantiate()
                    vc.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    self.showPermissionAlert()
                }
            }
        }
    }
    
    private func showPermissionAlert() {
        let alertController = UIAlertController(title: "You did not give access to 'Contacts'",
                                                message: "We need access to the “Contacts”. Please go to the settings and allow access, then restart the app.",
                                                preferredStyle: .alert)
        let disallowAction = UIAlertAction(title: "Disallow", style: .cancel)
        let settingsAction = UIAlertAction(title: "In settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl) { _ in }
            }
        }
        alertController.addAction(disallowAction)
        alertController.addAction(settingsAction)
        present(alertController, animated: true, completion: nil)
    }
    
    deinit {
        print("deinit contacts menu")
    }
}

extension ContactsMenuViewController: ViewControllerProtocol {
    func setupUI() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.contactManager.countUnresolvedContacts { duplicatedByName, duplicatedByNumber, noName, noNumber, summaryCount in
                DispatchQueue.main.async {
                    self?.unresolvedContactsCount.bind(text: "\(summaryCount) contact\(summaryCount == 1 ? "" : "s")")
                    
                    self?.duplicateNamesView.unresolvedItemsCount.bind(text: "\(duplicatedByName) contact\(duplicatedByName == 1 ? "" : "s")")
                    self?.duplicateNumbersView.unresolvedItemsCount.bind(text: "\(duplicatedByNumber) contact\(duplicatedByNumber == 1 ? "" : "s")")
                    self?.noNameView.unresolvedItemsCount.bind(text: "\(noName) contact\(noName == 1 ? "" : "s")")
                    self?.noNumberView.unresolvedItemsCount.bind(text: "\(noNumber) contact\(noNumber == 1 ? "" : "s")")
                }
            }
        }
    }
    
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
        
        contentSV.refreshControl = UIRefreshControl()
        contentSV.refreshControl?.addTarget(self, action: #selector(refreshUI), for: .valueChanged)
    }
    
    
    @objc func refreshUI() {
        setupUI()
        contentSV.refreshControl?.endRefreshing()
    }
    
    private func checkPermissionStatus() {
        contactStore.requestAccess(for: .contacts) { [weak self] (granted, error) in
            guard let self else { return }
            if granted {
                DispatchQueue.main.async { self.addGestureRecognizers() }
            } else {
                DispatchQueue.main.async { self.showPermissionAlert() }
            }
        }
    }
}

extension ContactsMenuViewController: ContactsMenuViewProtocol {
    func tapOnCell(type: ContactsInfoType) {
        let vc: UIViewController = switch type {
        case .duplicateNames:
            StoryboardScene.DuplicateNameContacts.initialScene.instantiate()
        case .dublicateNumbers:
            DuplicateNumberContactsViewController()
        case .noNameContacts:
            StoryboardScene.NoNameContacts.initialScene.instantiate()
        case .noNumberContacts:
            StoryboardScene.NoNumberContacts.initialScene.instantiate()
        }
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
}
