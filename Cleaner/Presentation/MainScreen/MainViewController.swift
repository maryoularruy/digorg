//
//  MainViewController.swift
//  Cleaner
//
//  Created by Максим Лебедев on 13.07.2023.
//

import UIKit
import SwiftyUserDefaults
import Contacts

class MainViewController: UIViewController {

    @IBOutlet weak var phoneInfoStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
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
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: MainFirstCell.self)
        collectionView.register(cellType: MainSecondCell.self)
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
            guard let self = self else { return }
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

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = self.collectionView.dequeueReusableCell(for: indexPath) as MainFirstCell
            cell.storiesView.addTapGestureRecognizer {
                let vc = StoryboardScene.Stories.initialScene.instantiate()
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.CalendarView.addTapGestureRecognizer {
                let vc = StoryboardScene.CalendarList.initialScene.instantiate()
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.contactsView.addTapGestureRecognizer {
                self.checkAccessStatus()
            }
            cell.mediaView.addTapGestureRecognizer {
                let vc = StoryboardScene.PhotoVideoMenu.initialScene.instantiate()
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        } else {
            let cell = self.collectionView.dequeueReusableCell(for: indexPath) as MainSecondCell
            cell.connectionView.addTapGestureRecognizer {
                let vc = StoryboardScene.Connection.initialScene.instantiate()
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.batteryView.addTapGestureRecognizer {
                let vc = StoryboardScene.MainBattery.initialScene.instantiate()
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.adBlockView.addTapGestureRecognizer {
                let vc = StoryboardScene.AdBlocker.initialScene.instantiate()
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.settingsView.addTapGestureRecognizer {
                let vc = StoryboardScene.Settings.initialScene.instantiate()
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.passwordsView.addTapGestureRecognizer {
                let vc = StoryboardScene.PasswordList.initialScene.instantiate()
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.secretFoldersView.addTapGestureRecognizer {
                AppLocker.present(with: .create)
            }
            return cell
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width - 48, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        48
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
}
