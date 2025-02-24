//
//  SmartCleanViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 04.02.2025.
//

import UIKit

final class SmartCleanViewController: UIViewController {
    private lazy var rootView = SmartCleanView()
    
    private lazy var photoVideoManager = PhotoVideoManager.shared
    private lazy var contactManager = ContactManager.shared
    private lazy var calendarManager = CalendarManager.shared
    
    private var isFirstEntry: Bool = true
    
    private var itemsCount: Int {
        photoVideoManager.selectedPhotosForSmartCleaning.count +
        photoVideoManager.selectedScreenshotsForSmartCleaning.count +
        photoVideoManager.selectedVideosForSmartCleaning.count +
        calendarManager.selectedEventsForSmartCleaning.count +
        contactManager.selectedContactsForSmartCleaning.count
    }
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
        rootView.smartCleanStackViewCells.forEach { $0.delegate = self }
        rootView.actionToolbar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
    }
    
    private func getItemsSize(handler: @escaping (Int64) -> Void) {
        var totalSize: Int64 = 0
        let dispatchGroup = DispatchGroup()
        
        [photoVideoManager.selectedPhotosForSmartCleaning,
         photoVideoManager.selectedScreenshotsForSmartCleaning,
         photoVideoManager.selectedVideosForSmartCleaning].forEach { assets in
            dispatchGroup.enter()
            assets.getAssetsSize { size in
                totalSize += size
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            handler(totalSize)
        }
    }
}

extension SmartCleanViewController: ViewControllerProtocol {
    func setupUI() {
        if isFirstEntry {
            let progressStep: Double = 100.0 / 5
            rootView.scanningStorageView.resetProgress()
            rootView.startSpinner()
            
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            photoVideoManager.fetchSimilarPhotos(live: false) { [weak self] assetGroups, _, _ in
                guard let self else { return }
                photoVideoManager.selectedPhotosForSmartCleaning = photoVideoManager.join(assetGroups)
                rootView.scanningStorageView.bind(.scanning, value: progressStep)
                rootView.duplicatePhotosCleanCell.bind(itemsCount: photoVideoManager.selectedPhotosForSmartCleaning.count)
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            photoVideoManager.fetchScreenshots { [weak self] screenshots in
                guard let self else { return }
                photoVideoManager.selectedScreenshotsForSmartCleaning = screenshots
                rootView.scanningStorageView.bind(.scanning, value: progressStep)
                rootView.screenshotsCleanCell.bind(itemsCount: photoVideoManager.selectedScreenshotsForSmartCleaning.count)
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            photoVideoManager.fetchSimilarVideos { [weak self] assetGroups, _, size in
                guard let self else { return }
                photoVideoManager.selectedVideosForSmartCleaning = photoVideoManager.join(assetGroups)
                rootView.scanningStorageView.bind(.scanning, value: progressStep)
                rootView.duplicateVideosCleanCell.bind(itemsCount: photoVideoManager.selectedVideosForSmartCleaning.count)
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            calendarManager.fetchEvents { [weak self] events in
                guard let self else { return }
                calendarManager.selectedEventsForSmartCleaning = events
                rootView.scanningStorageView.bind(.scanning, value: progressStep)
                rootView.calendarCleanCell.bind(itemsCount: calendarManager.selectedEventsForSmartCleaning.count)
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            contactManager.loadIncompletedByNumber { [weak self] contacts in
                guard let self else { return }
                contactManager.selectedContactsForSmartCleaning = contacts
                rootView.scanningStorageView.bind(.scanning, value: progressStep)
                rootView.contactsCleanCell.bind(itemsCount: contactManager.selectedContactsForSmartCleaning.count)
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) { [weak self] in
                self?.updateUI()
                self?.isFirstEntry = false
            }
        } else {
            rootView.duplicatePhotosCleanCell.bind(itemsCount: photoVideoManager.selectedPhotosForSmartCleaning.count)
            rootView.screenshotsCleanCell.bind(itemsCount: photoVideoManager.selectedScreenshotsForSmartCleaning.count)
            rootView.duplicateVideosCleanCell.bind(itemsCount: photoVideoManager.selectedVideosForSmartCleaning.count)
            rootView.calendarCleanCell.bind(itemsCount: calendarManager.selectedEventsForSmartCleaning.count)
            rootView.contactsCleanCell.bind(itemsCount: contactManager.selectedContactsForSmartCleaning.count)
            updateUI()
        }
    }
    
    func addGestureRecognizers() {
        rootView.arrowBack.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }
    
    private func updateUI() {
        getItemsSize { [weak self] finalSize in
            guard let self else { return }
            rootView.scanningStorageView.bind(.scanningDone, value: 100, finalSize: finalSize)
            rootView.actionToolbar.toolbarButton.isClickable = itemsCount == 0 ? false : true
            rootView.actionToolbar.toolbarButton.bind(text: "Delete \(itemsCount) item\(itemsCount == 1 ? "" : "s"), \(finalSize.roundAndToString())")
        }
    }
}

extension SmartCleanViewController: SmartCleanCellDelegate {
    func tapOnManageButton(_ type: SmartCleanCellType) {
        let vc = switch type {
        case .calendar:
            StoryboardScene.Calendar.initialScene.instantiate()
        case .contacts:
            StoryboardScene.NoNumberContacts.initialScene.instantiate()
        case .duplicatePhotos:
            StoryboardScene.GroupedAssets.initialScene.instantiate()
        case .screenshots:
            RegularAssetsViewController(type: .screenshots)
        case .duplicatesVideos:
            StoryboardScene.GroupedAssets.initialScene.instantiate()
        }
        
        switch type {
        case .calendar:
            (vc as? CalendarViewController)?.from = .smartClean
        case .contacts:
            (vc as? NoNumberContactsViewController)?.from = .smartClean
        case .duplicatePhotos:
            (vc as? GroupedAssetsViewController)?.type = .duplicatePhotos
            (vc as? GroupedAssetsViewController)?.from = .smartClean
        case .screenshots:
            (vc as? RegularAssetsViewController)?.from = .smartClean
        case .duplicatesVideos:
            (vc as? GroupedAssetsViewController)?.type = .duplicateVideos
            (vc as? GroupedAssetsViewController)?.from = .smartClean
        }
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SmartCleanViewController: ActionToolbarDelegate {
    func tapOnActionButton() {
        let vc = CleaningAssetsViewController(from: .smartClean, itemsCount: itemsCount)
        vc.modalPresentationStyle = .currentContext
        navigationController?.pushViewController(vc, animated: false)
    }
}
