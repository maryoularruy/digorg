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
        subscriptionInfoView.isHidden = true
        //
    }
}

extension SettingsViewController: ViewControllerProtocol {
    func setupUI() {
        subscriptionInfoView.bind(views: SettingsOption.subscriptionOption)
        subscriptionStackView.addArrangedSubview(buyPremiumView)
        subscriptionStackView.addArrangedSubview(subscriptionInfoView)
        buyPremiumView.delegate = self
        subscriptionInfoView.delegate = self
        
        removeAfterImportContainer.bind(views: SettingsOption.removeAfterImportOptions)
        removeAfterImportContainer.delegate = self
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
