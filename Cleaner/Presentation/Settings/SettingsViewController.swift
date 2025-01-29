//
//  SettingsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.11.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
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
        setupSubscriptionStackView()
    }
    
    private func setupSubscriptionStackView() {
//        buyPremiumView.isHidden = !userDefaultsService.isSubscriptionActive
//        subscriptionInfoView.isHidden = userDefaultsService.isSubscriptionActive
        
        //
        buyPremiumView.isHidden = true
        //
    }
}

extension SettingsViewController: ViewControllerProtocol {
    func setupUI() {
        subscriptionInfoView.bind(options: SettingsOption.subscriptionOption, isDefaultHeight: true)
        subscriptionStackView.addArrangedSubview(buyPremiumView)
        subscriptionStackView.addArrangedSubview(subscriptionInfoView)
        buyPremiumView.delegate = self
        subscriptionInfoView.delegate = self
        
        removeAfterImportContainer.bind(options: SettingsOption.removeAfterImportOptions, isDefaultHeight: false)
        removeAfterImportContainer.delegate = self
        
        passcodeOptionsContainer.bind(options: SettingsOption.passcodeOptions, isDefaultHeight: false)
        passcodeOptionsContainer.delegate = self
        
        applicationOptionsContainer.bind(options: SettingsOption.applicationOptions, isDefaultHeight: true)
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
        
    }
}
