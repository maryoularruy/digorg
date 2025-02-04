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
    
    private var itemsSize: Int64 {
        photoVideoManager.selectedPhotosForSmartCleaning.reduce(0) { $0 + $1.imageSize } +
        photoVideoManager.selectedScreenshotsForSmartCleaning.reduce(0) { $0 + $1.imageSize } +
        photoVideoManager.selectedVideosForSmartCleaning.reduce(0) { $0 + $1.imageSize }
    }
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
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
            guard let self else { return }
            rootView.scanningStoreView.bind(.scanningDone, value: 100, finalSize: itemsSize)
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
