//
//  SettingsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.11.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    @IBOutlet weak var removeAfterImportContainer: SettingsOptionsContainer!
    @IBOutlet weak var passcodeOptionsContainer: SettingsOptionsContainer!
    @IBOutlet weak var applicationOptionsContainer: SettingsOptionsContainer!
    
    private lazy var userDefaultsService = UserDefaultsService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserDefaultsKeys()
        updateSettingsContainers()
    }
    
    private func updateUserDefaultsKeys() {
        if userDefaultsService.get(Bool.self, key: .isPasscodeTurnOn) == nil {
            userDefaultsService.set(true, key: .isPasscodeTurnOn)
        }
        
        if userDefaultsService.get(Bool.self, key: .isRemovePhotosAfterImport) == nil {
            userDefaultsService.set(true, key: .isRemovePhotosAfterImport)
        }
        
        if userDefaultsService.get(Bool.self, key: .isRemoveContactsAfterImport) == nil {
            userDefaultsService.set(true, key: .isRemoveContactsAfterImport)
        }
    }
    

    
    private func updateSettingsContainers() {
        removeAfterImportContainer.bind(options: removeAfterImportOptions, isDefaultHeight: false)
        passcodeOptionsContainer.bind(options: passcodeOptions, isDefaultHeight: false)
    }
    

    
    private func openWebVC(isPrivacyPolicy: Bool) {
        let vc = WebViewController(isPrivacyPolicy: isPrivacyPolicy)
        vc.modalPresentationStyle = .popover
        present(vc, animated: true)
    }
}



extension SettingsViewController: ViewControllerProtocol {
    func setupUI() {
        applicationOptionsContainer.bind(options: SettingsOption.applicationOptions, isDefaultHeight: true)
        
        removeAfterImportContainer.delegate = self
        passcodeOptionsContainer.delegate = self
        applicationOptionsContainer.delegate = self
    }
    
    func addGestureRecognizers() {}
}



extension SettingsViewController: SettingsOptionsContainerDelegate {
    func tapOnOption(_ option: SettingsOption) {
        switch option.type {
        case .subscriptionInfo:
            // Подписка больше не нужна, так как все функции доступны
            break
            
        case .photosRemovable:
            userDefaultsService.set(option.isSwitchable, key: .isRemovePhotosAfterImport)
        case .contactsRemovable:
            userDefaultsService.set(option.isSwitchable, key: .isRemoveContactsAfterImport)
        case .usePasscode:
            userDefaultsService.set(option.isSwitchable, key: .isPasscodeTurnOn)
            
        case .changePassword:
            let vc = SecurityQuestionViewController()
            vc.type = .change
            vc.modalPresentationStyle = .fullScreen
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
        case .share:
            guard let url = NSURL(string: "https://apps.apple.com/app/6741464903") else { return }
            let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            vc.popoverPresentationController?.sourceView = self.view
            present(vc, animated: true)
            
        case .sendFeedback:
            if let url = URL(string: "mailto:\("maryoularruy@gmail.com")?subject=\("Feedback about Digital Organizer")&body=\("")"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        case .privacyPolicy:
            openWebVC(isPrivacyPolicy: true)
        case .termsOfUse:
            openWebVC(isPrivacyPolicy: false)
        }
    }
}
