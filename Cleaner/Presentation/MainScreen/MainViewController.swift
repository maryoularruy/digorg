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
    @IBOutlet weak var photosCleanup: CleanupOptionView!
    @IBOutlet weak var videosCleanup: CleanupOptionView!
    @IBOutlet weak var contactsCleanup: CleanupOptionView!
    @IBOutlet weak var calendarCleanup: CleanupOptionView!
    
    private lazy var mediaService = MediaService.shared
    private lazy var contactManager = ContactManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
        storageUsageView.usedMemoryLabel.text = "45 / 234 GB"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkPhotoLibraryAccessStatus()
        checkContactsAccessStatus()
        checkCalendarAccessStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        storageUsageView.circularProgressBarView.progressAnimation(0.65)
    }
    
    private func checkPhotoLibraryAccessStatus() {
        mediaService.checkStatus { [weak self] status in
            if #available(iOS 14, *) {
                if status == .authorized || status == .limited {
                    self?.updatePhotosCleanupOption()
                    self?.updateVideosCleanupOption()
                }
            } else {
                if status == .authorized {
                    self?.updatePhotosCleanupOption()
                    self?.updateVideosCleanupOption()
                }
            }
        }
    }
    
    private func checkContactsAccessStatus() {
        contactManager.checkStatus { status in
            if #available(iOS 18.0, *) {
                if status == .authorized || status == .limited {
                    
                }
            } else {
                if status == .authorized {
                    
                }
            }
        }
    }
    
    private func checkCalendarAccessStatus() {
        
    }
    
    private func updatePhotosCleanupOption() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.mediaService.loadSimilarPhotos(live: false) { _, duplicatesCount in
                DispatchQueue.main.async {
                    self?.photosCleanup.infoButton.bind(duplicatesCount: duplicatesCount)
                }
            }
        }
    }
    
    private func updateVideosCleanupOption() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.mediaService.loadSimilarVideos { _, duplicatesCount in
                DispatchQueue.main.async {
                    self?.videosCleanup.infoButton.bind(duplicatesCount: duplicatesCount)
                }
            }
        }
    }
    
    private func updateContactsCleanupOption() {
//        DispatchQueue.global(qos: .background).async { [weak self] in
//            ContactManager.loadDuplicatedByName { contacts in
//                
//            }
//        }
    }
}

extension MainViewController: ViewControllerProtocol {
    func setupUI() {
        bindDeviceInfoStackView()
        setupDeviceInfoSection()
        photosCleanup.bind(.photos)
        videosCleanup.bind(.videos)
        contactsCleanup.bind(.contacts)
        calendarCleanup.bind(.calendar)
    }
    
    func addGestureRecognizers() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openPhoneInfoScreen))
        deviceInfoLabel.addTapGestureRecognizer(action: openPhoneInfoScreen)
        deviceInfoStackView.addGestureRecognizer(gesture)
        
        photosCleanup.addTapGestureRecognizer(action: openPhotosCleanup)
        photosCleanup.infoButton.addTapGestureRecognizer(action: openPhotosCleanup)
        videosCleanup.addTapGestureRecognizer(action: openVideosCleanup)
        videosCleanup.infoButton.addTapGestureRecognizer(action: openVideosCleanup)
        contactsCleanup.addTapGestureRecognizer(action: openContactsCleanup)
        contactsCleanup.infoButton.addTapGestureRecognizer(action: openContactsCleanup)
        calendarCleanup.addTapGestureRecognizer(action: openCalendarCleanup)
        calendarCleanup.infoButton.addTapGestureRecognizer(action: openCalendarCleanup)
    }
    
    @objc private func openPhoneInfoScreen() {
        let vc = StoryboardScene.PhoneInfo.initialScene.instantiate()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupDeviceInfoSection() {
        updateData()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateSpeed), userInfo: nil, repeats: true)
    }
    
    private func bindDeviceInfoStackView() {
        if deviceInfoStackView.arrangedSubviews.isEmpty {
            Title.allCases.forEach { title in
                deviceInfoStackView.addArrangedSubview(DeviceInfoCell(cell: title))
            }
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
    
    private func openPhotosCleanup() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            navigationController?.pushViewController(createSearchVC(with: .photos), animated: true)
        }
    }
    
    private func openVideosCleanup() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            navigationController?.pushViewController(createSearchVC(with: .photos), animated: true)
        }
    }
    
    private func openContactsCleanup() {
        let vc = StoryboardScene.ContactsMenu.initialScene.instantiate()
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func openCalendarCleanup() {
        let vc = StoryboardScene.Calendar.initialScene.instantiate()
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func createSearchVC(with cleanupOption: CleanupOption) -> SearchViewController {
        let vc = StoryboardScene.Search.initialScene.instantiate()
        vc.modalPresentationStyle = .fullScreen
        vc.setCleanupOption(cleanupOption)
        return vc
    }
}
