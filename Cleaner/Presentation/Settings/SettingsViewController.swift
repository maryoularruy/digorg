//
//  SettingsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.11.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    @IBOutlet weak var premiumIcon: UIImageView!
    @IBOutlet weak var subscriptionStackView: UIStackView!
    @IBOutlet weak var removeAfterImportContainer: SettingsOptionsContainer!
    @IBOutlet weak var passcodeOptionsContainer: SettingsOptionsContainer!
    @IBOutlet weak var applicationOptionsContainer: SettingsOptionsContainer!
    
    private lazy var buyPremiumView = BuyPremiumView()
    private lazy var subscriptionInfoView = SettingsOptionsContainer()
    
    private lazy var userDefaultsService = UserDefaultsService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserDefaultsKeys()
        updateSubscriptionUI()
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
    
    private func updateSubscriptionUI() {
        premiumIcon.isHidden = userDefaultsService.isSubscriptionActive
        buyPremiumView.isHidden = !userDefaultsService.isSubscriptionActive
        subscriptionInfoView.isHidden = userDefaultsService.isSubscriptionActive
    }
    
    private func updateSettingsContainers() {
        removeAfterImportContainer.bind(options: removeAfterImportOptions, isDefaultHeight: false)
        passcodeOptionsContainer.bind(options: passcodeOptions, isDefaultHeight: false)
    }
}

extension SettingsViewController: ViewControllerProtocol {
    func setupUI() {
        subscriptionInfoView.bind(options: SettingsOption.subscriptionOption, isDefaultHeight: true)
        subscriptionStackView.addArrangedSubview(buyPremiumView)
        subscriptionStackView.addArrangedSubview(subscriptionInfoView)
        applicationOptionsContainer.bind(options: SettingsOption.applicationOptions, isDefaultHeight: true)
        
        buyPremiumView.delegate = self
        subscriptionInfoView.delegate = self
        removeAfterImportContainer.delegate = self
        passcodeOptionsContainer.delegate = self
        applicationOptionsContainer.delegate = self
    }
    
    func addGestureRecognizers() {}
}

extension SettingsViewController: BuyPremiumViewDelegate {
    func tapOnStartTrial() {
        let vc = PremiumViewController()
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
}

extension SettingsViewController: SettingsOptionsContainerDelegate {
    func tapOnOption(_ option: SettingsOption) {
        switch option.type {
        case .subscriptionInfo:
            break
        case .photosRemovable:
            userDefaultsService.set(option.isSwitchable, key: .isRemovePhotosAfterImport)
        case .contactsRemovable:
            userDefaultsService.set(option.isSwitchable, key: .isRemoveContactsAfterImport)
        case .usePasscode:
            userDefaultsService.set(option.isSwitchable, key: .isPasscodeTurnOn)
        case .changePassword:
            break
        case .share:
            //TODO
            break
        case .sendFeedback:
            //TODO
            break
        case .privacyPolicy:
            //TODO
            break
        case .termsOfUse:
            //TODO
            break
        }
    }
}
