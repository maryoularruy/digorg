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
//        testView.isHidden = userDefaultsService.isSubscriptionActive
        
        //
//        testView.isHidden = true
        //
    }
}

extension SettingsViewController: ViewControllerProtocol {
    func setupUI() {
        subscriptionStackView.addArrangedSubview(buyPremiumView)
        //
//        subscriptionStackView.addArrangedSubview(testView)
        //
        
        buyPremiumView.delegate = self
        
        //
        removeAfterImportContainer.bind(views: [SettingsOption(title: "Subscription", type: .subscriptionInfo),
                                                SettingsOption(title: "Sub", type: .subscriptionInfo),
                                                SettingsOption(title: "asi", isSwitchable: true, type: .changePassword)])
        //
        
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
