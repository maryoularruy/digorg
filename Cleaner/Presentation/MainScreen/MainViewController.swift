//
//  MainViewController.swift
//  Cleaner
//
//  Created by Максим Лебедев on 13.07.2023.
//

import UIKit
import Contacts

final class MainViewController: UIViewController {

    @IBOutlet weak var deviceInfoLabel: UILabel!
    @IBOutlet weak var deviceInfoStackView: UIStackView!
    @IBOutlet weak var storageUsageView: StorageUsageView!
    @IBOutlet weak var cleanupOptionsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDeviceInfoSection()
        setupCleanupOptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addGestureRecognizers()
        storageUsageView.usedMemoryLabel.text = "45 / 234 GB"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        storageUsageView.circularProgressBarView.progressAnimation(0.65)
    }
    
    private func setupDeviceInfoSection() {
        bindDeviceInfoStackView()
        updateData()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateSpeed), userInfo: nil, repeats: true)
    }
    
    private func bindDeviceInfoStackView() {
        Title.allCases.forEach { title in
            deviceInfoStackView.addArrangedSubview(DeviceInfoCell(cell: title))
        }
    }

    @objc func updateData() {
        PhoneInfoService.shared.getFreeRAM()
        PhoneInfoService.shared.getBusyCPU()
        
        (deviceInfoStackView.arrangedSubviews[Title.available.index] as? DeviceInfoCell)?.bind(newValue: PhoneInfoService.shared.freeRAM)
        
        (deviceInfoStackView.arrangedSubviews[Title.used.index] as? DeviceInfoCell)?.bind(newValue: PhoneInfoService.shared.busyCPU)
    }
    
    @objc func updateSpeed() {
        (deviceInfoStackView.arrangedSubviews[Title.download.index] as? DeviceInfoCell)?.bind(newValue: PhoneInfoService.shared.downloadSpeed)
    }
    
    private func setupCleanupOptions() {
        CleanupOption.allCases.forEach { option in
            let view = CleanupOptionView()
            view.bind(option)
            cleanupOptionsStackView.addArrangedSubview(view)
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

extension MainViewController: MainViewControllerProtocol {
    func addGestureRecognizers() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openPhoneInfoScreen))
        deviceInfoLabel.addTapGestureRecognizer(action: openPhoneInfoScreen)
        deviceInfoStackView.addGestureRecognizer(gesture)
    }
    
    @objc private func openPhoneInfoScreen() {
        let vc = StoryboardScene.PhoneInfo.initialScene.instantiate()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
}
