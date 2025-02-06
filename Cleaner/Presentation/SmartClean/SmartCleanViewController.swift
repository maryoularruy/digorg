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
        rootView.actionToolbar.delegate = self
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
    
    deinit {
        print("SmartCleanViewController deinit")
    }
}

extension SmartCleanViewController: ViewControllerProtocol {
    func setupUI() {
        let progressStep: Double = 100.0 / 5
        rootView.scanningStoreView.resetProgress()
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        photoVideoManager.fetchSimilarPhotos(live: false) { [weak self] assetGroups, _, _ in
            guard let self else { return }
            photoVideoManager.selectedPhotosForSmartCleaning = photoVideoManager.join(assetGroups)
            rootView.scanningStoreView.bind(.scanning, value: progressStep)
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        photoVideoManager.fetchScreenshots { [weak self] screenshots in
            guard let self else { return }
            photoVideoManager.selectedScreenshotsForSmartCleaning = screenshots
            rootView.scanningStoreView.bind(.scanning, value: progressStep)
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        photoVideoManager.fetchSimilarVideos { [weak self] assetGroups, _, size in
            guard let self else { return }
            photoVideoManager.selectedVideosForSmartCleaning = photoVideoManager.join(assetGroups)
            rootView.scanningStoreView.bind(.scanning, value: progressStep)
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        calendarManager.fetchEvents { [weak self] events in
            guard let self else { return }
            calendarManager.selectedEventsForSmartCleaning = events
            rootView.scanningStoreView.bind(.scanning, value: progressStep)
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        contactManager.loadIncompletedByNumber { [weak self] contacts in
            guard let self else { return }
            contactManager.selectedContactsForSmartCleaning = contacts
            rootView.scanningStoreView.bind(.scanning, value: progressStep)
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.getItemsSize { [weak self] finalSize in
                guard let self else { return }
                rootView.scanningStoreView.bind(.scanningDone, value: 100, finalSize: finalSize)
                rootView.actionToolbar.toolbarButton.isClickable = itemsCount == 0 ? false : true
                rootView.actionToolbar.toolbarButton.bind(text: "Delete \(itemsCount) item\(itemsCount == 1 ? "" : "s"), \(finalSize.convertToString())")
            }
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
}

extension SmartCleanViewController: ActionToolbarDelegate {
    func tapOnActionButton() {
        let vc = CleaningAssetsViewController(from: .smartClean, itemsForDeleting: itemsCount)
        vc.modalPresentationStyle = .currentContext
        navigationController?.pushViewController(vc, animated: false)
    }
}
