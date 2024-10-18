//
//  ContactsMenuViewController.swift
//  Cleaner
//
//  Created by Максим Лебедев on 20.10.2023.
//

import UIKit
import Contacts

final class ContactsMenuViewController: UIViewController {
    @IBOutlet weak var arrowBackView: UIView!
    @IBOutlet weak var unresolvedContactsCount: Regular13LabelStyle!
    @IBOutlet weak var duplicateNamesView: ContactsMenuView!
    @IBOutlet weak var duplicateNumbersView: ContactsMenuView!
    @IBOutlet weak var noNameView: ContactsMenuView!
    @IBOutlet weak var noNumberView: ContactsMenuView!
    
    private lazy var contactStore = CNContactStore()
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

extension ContactsMenuViewController: ViewControllerProtocol {
    func setupUI() {
        unresolvedContactsCount.bind(text: "50 contacts")
        duplicateNamesView.bind(type: .duplicateNames)
        duplicateNumbersView.bind(type: .dublicateNumbers)
        noNameView.bind(type: .noNameContacts)
        noNumberView.bind(type: .noNumberContacts)
    }
    
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        [duplicateNamesView, duplicateNumbersView,
         noNameView, noNumberView].forEach { $0.delegate = self }
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
            StoryboardScene.DuplicateContacts.initialScene.instantiate()
        case .dublicateNumbers:
            StoryboardScene.DuplicateContacts.initialScene.instantiate()
        case .noNameContacts:
            StoryboardScene.IncompliteContacts.initialScene.instantiate()
        case .noNumberContacts:
            StoryboardScene.IncompliteContacts.initialScene.instantiate()
        }
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
}
