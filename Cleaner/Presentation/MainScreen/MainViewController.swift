//
//  MainViewController.swift
//  Cleaner
//
//  Created by Максим Лебедев on 13.07.2023.
//

import UIKit
import Contacts

class MainViewController: UIViewController {

    @IBOutlet weak var phoneInfoStackView: UIStackView!
    @IBOutlet weak var busyCPULabel: UILabel!
    @IBOutlet weak var totalRAMLabel: UILabel!
    @IBOutlet weak var freeRAMLabel: UILabel!
    @IBOutlet weak var downoladSpeedLabel: UILabel!
    
    var timer: Timer?
    var speedTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPhoneInfoSection()
        setupActions()
    }
    
    private func setupPhoneInfoSection() {
        updateData()
        downoladSpeedLabel.text = PhoneInfoService.shared.downloadSpeed
        totalRAMLabel.text = PhoneInfoService.shared.totalRAM
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        speedTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateSpeed), userInfo: nil, repeats: true)
    }

    @objc func updateData() {
        PhoneInfoService.shared.getFreeRAM()
        PhoneInfoService.shared.getBusyCPU()
        freeRAMLabel.text = PhoneInfoService.shared.freeRAM
        busyCPULabel.text = PhoneInfoService.shared.busyCPU
    }
    
    @objc func updateSpeed() {
        downoladSpeedLabel.text = PhoneInfoService.shared.downloadSpeed
    }
    
    private func setupActions() {
        phoneInfoStackView.addTapGestureRecognizer {
            let vc = StoryboardScene.PhoneInfo.initialScene.instantiate()
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl) { _ in }
            }
        }
        alertController.addAction(disallowAction)
        alertController.addAction(settingsAction)
        present(alertController, animated: true, completion: nil)
    }
}
