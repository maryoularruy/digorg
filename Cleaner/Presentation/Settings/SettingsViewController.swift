//
//  SettingsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.11.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    @IBOutlet weak var buyPremiumView: BuyPremiumView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension SettingsViewController: ViewControllerProtocol {
    func setupUI() {
        buyPremiumView.delegate = self
    }
    
    func addGestureRecognizers() {}
}

extension SettingsViewController: BuyPremiumViewDelegate {
    func tapOnStartTrial() {
        
    }
}



