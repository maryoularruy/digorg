//
//  MainViewController.swift
//  Cleaner
//
//  Created by Максим Лебедев on 13.07.2023.
//

import UIKit
import Contacts

final class MainViewController: UIViewController {
    @IBOutlet weak var premiumImageView: UIImageView!
    
    @IBOutlet weak var deviceInfoLabel: UILabel!
    @IBOutlet weak var deviceInfoStackView: UIStackView!
    @IBOutlet weak var storageUsageView: StorageUsageView!
    
    @IBOutlet weak var cleanupOptionsStackView: UIStackView!
    @IBOutlet weak var photosCleanup: CleanupOptionView!
    @IBOutlet weak var videosCleanup: CleanupOptionView!
    @IBOutlet weak var contactsCleanup: CleanupOptionView!
    @IBOutlet weak var calendarCleanup: CleanupOptionView!
    
    private lazy var photoVideoManager = PhotoVideoManager.shared
    private lazy var contactManager = ContactManager.shared
    private lazy var calendarManager = CalendarManager.shared
    private lazy var userDefaultsService = UserDefaultsService.shared
    
    private var timer: Timer?
    private var speedTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        timer = nil
        speedTimer?.invalidate()
        speedTimer = nil
    }
    
    private func updateUI() {
        premiumImageView.isHidden = !userDefaultsService.isSubscriptionActive
        
        setupDeviceInfoSection()
        setupStorageUsageSection()
        checkPhotoLibraryAccessStatus()
        checkContactsAccessStatus()
        checkCalendarAccessStatus()
    }
    
    private func setupDeviceInfoSection() {
        updateRamAndCpu()
        updateSpeed()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateRamAndCpu), userInfo: nil, repeats: true)
        speedTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateSpeed), userInfo: nil, repeats: true)
    }
    
    @objc func updateRamAndCpu() {
        (deviceInfoStackView.arrangedSubviews[Title.available.index] as? DeviceInfoCell)?.bind(newValue: DeviceInfoService.shared.freeRam.toStringWithDot())
        
        (deviceInfoStackView.arrangedSubviews[Title.used.index] as? DeviceInfoCell)?.bind(newValue: "\(String(format: "%.1f", DeviceInfoService.shared.busyCpu)) %")
    }
    
    @objc func updateSpeed() {
        if let downloadInfo = DeviceInfoService.shared.downloadInfo {
            (deviceInfoStackView.arrangedSubviews[Title.download.index] as? DeviceInfoCell)?.bind(newValue: downloadInfo.humanReadableNumber + " " + downloadInfo.humanReadableNumberUnit)
        } else {
            (deviceInfoStackView.arrangedSubviews[Title.download.index] as? DeviceInfoCell)?.bind(newValue: "0 KB/s")
        }
    }
    
    private func setupStorageUsageSection() {
        storageUsageView.updateData()
    }
    
    private func checkPhotoLibraryAccessStatus() {
        photoVideoManager.checkStatus { [weak self] status in
            if status == .authorized || status == .limited {
                self?.updatePhotosCleanupOption()
                self?.updateVideosCleanupOption()
            }
        }
    }
    
    private func checkContactsAccessStatus() {
        contactManager.checkStatus { [weak self] status in
            if #available(iOS 18.0, *) {
                if status == .authorized || status == .limited {
                    self?.updateContactsCleanupOption()
                }
            } else {
                if status == .authorized {
                    self?.updateContactsCleanupOption()
                }
            }
        }
    }
    
    private func checkCalendarAccessStatus() {
        calendarManager.checkStatus { [weak self] status in
            if #available(iOS 17.0, *) {
                if status == .authorized || status == .fullAccess || status == .writeOnly {
                    self?.updateCalendarCleanupOption()
                }
            } else {
                if status == .authorized {
                    self?.updateCalendarCleanupOption()
                }
            }
        }
    }
    
    private func updatePhotosCleanupOption() {
        photosCleanup.infoButton.startSpinner()
        photosCleanup.isUserInteractionEnabled = false
        photoVideoManager.fetchSimilarPhotos(live: false) { assetsGroups, duplicatesCount, size in
            DispatchQueue.main.async { [weak self] in
                self?.photosCleanup.infoButton.endSpinner()
                self?.photosCleanup.infoButton.bind(text: "\(duplicatesCount) file\(duplicatesCount == 1 ? "" : "s"), \(size.roundAndToString())")
                self?.photosCleanup.isUserInteractionEnabled = true
            }
        }
    }
    
    private func updateVideosCleanupOption() {
        videosCleanup.infoButton.startSpinner()
        videosCleanup.isUserInteractionEnabled = false
        photoVideoManager.fetchSimilarVideos { _, duplicatesCount, size in
            DispatchQueue.main.async { [weak self] in
                self?.videosCleanup.infoButton.endSpinner()
                self?.videosCleanup.infoButton.bind(text: "\(duplicatesCount) file\(duplicatesCount == 1 ? "" : "s"), \(size.roundAndToString())")
                self?.videosCleanup.isUserInteractionEnabled = true
            }
        }
    }
    
    private func updateContactsCleanupOption() {
        contactsCleanup.infoButton.startSpinner()
        contactsCleanup.isUserInteractionEnabled = false
        contactManager.countUnresolvedContacts { _, _, _, _, summaryCount in
            DispatchQueue.main.async { [weak self] in
                self?.contactsCleanup.infoButton.endSpinner()
                self?.contactsCleanup.infoButton.bind(text: "\(summaryCount) contact\(summaryCount == 1 ? "" : "s")")
                self?.contactsCleanup.isUserInteractionEnabled = true
            }
        }
    }
    
    private func updateCalendarCleanupOption() {
        calendarCleanup.infoButton.startSpinner()
        calendarCleanup.isUserInteractionEnabled = false
        calendarManager.fetchEvents { events in
            DispatchQueue.main.async { [weak self] in
                self?.calendarCleanup.infoButton.endSpinner()
                self?.calendarCleanup.infoButton.bind(text: "\(events.count) event\(events.count == 1 ? "" : "s")")
                self?.calendarCleanup.isUserInteractionEnabled = true
            }
        }
    }
}

extension MainViewController: ViewControllerProtocol {
    func setupUI() {
        bindDeviceInfoStackView()
        photosCleanup.bind(.photos)
        videosCleanup.bind(.videos)
        contactsCleanup.bind(.contacts)
        calendarCleanup.bind(.calendar)
    }
    
    func addGestureRecognizers() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openDeviceInfoScreen))
        deviceInfoLabel.addTapGestureRecognizer(action: openDeviceInfoScreen)
        deviceInfoStackView.addGestureRecognizer(gesture)
        
        storageUsageView.addTapGestureRecognizer(action: openSmartClean)
        storageUsageView.analyzeStorageButton.addTapGestureRecognizer(action: openSmartClean)
        
        photosCleanup.addTapGestureRecognizer(action: openPhotosCleanup)
        photosCleanup.infoButton.addTapGestureRecognizer(action: openPhotosCleanup)
        videosCleanup.addTapGestureRecognizer(action: openVideosCleanup)
        videosCleanup.infoButton.addTapGestureRecognizer(action: openVideosCleanup)
        contactsCleanup.addTapGestureRecognizer(action: openContactsCleanup)
        contactsCleanup.infoButton.addTapGestureRecognizer(action: openContactsCleanup)
        calendarCleanup.addTapGestureRecognizer(action: openCalendarCleanup)
        calendarCleanup.infoButton.addTapGestureRecognizer(action: openCalendarCleanup)
    }
    
    @objc private func openDeviceInfoScreen() {
        let vc = DeviceInfoViewController()
        vc.hidesBottomBarWhenPushed = true
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func bindDeviceInfoStackView() {
        if deviceInfoStackView.arrangedSubviews.isEmpty {
            Title.allCases.forEach { title in
                deviceInfoStackView.addArrangedSubview(DeviceInfoCell(cell: title))
            }
        }
    }
    
    private func openSmartClean() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let vc = SmartCleanViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func openPhotosCleanup() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let vc = PhotoTotalViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func openVideosCleanup() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let vc = VideoTotalViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
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
}
