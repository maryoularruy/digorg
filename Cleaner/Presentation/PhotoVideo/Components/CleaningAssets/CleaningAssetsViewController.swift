//
//  CleaningAssetsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.12.2024.
//

import UIKit

enum EntryFrom {
    case smartClean, regularAssets
}

final class CleaningAssetsViewController: UIViewController {
    private lazy var rootView = CleaningAssetsView()
    
    private var from: EntryFrom
    private var itemsForDeletion: Int
    
    private lazy var photoVideoManager = PhotoVideoManager.shared
    private lazy var contactManager = ContactManager.shared
    private lazy var calendarManager = CalendarManager.shared
    
    init(from: EntryFrom, itemsForDeleting: Int) {
        self.from = from
        self.itemsForDeletion = itemsForDeleting
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch from {
        case .smartClean:
            startSmartCleaning()
        case .regularAssets:
            rootView.startProgress()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self else { return }
                showCongratsView(deletedItemsCount: itemsForDeletion)
            }
        }
    }
    
    private func showCongratsView(deletedItemsCount: Int) {
        rootView.showCongratsView(deletedItemsCount: deletedItemsCount)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }
    }
    
    private func startSmartCleaning() {
        let progressStep: Float = 1.0 / Float(itemsForDeletion)
        rootView.resetProgress()
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        if photoVideoManager.delete(assets: photoVideoManager.selectedPhotosForSmartCleaning) {
            rootView.addProgress(progressStep * Float(photoVideoManager.selectedPhotosForSmartCleaning.count))
            photoVideoManager.selectedPhotosForSmartCleaning.removeAll()
            dispatchGroup.leave()
        } else {
            rootView.addProgress(progressStep * Float(photoVideoManager.selectedPhotosForSmartCleaning.count))
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        if photoVideoManager.delete(assets: photoVideoManager.selectedScreenshotsForSmartCleaning) {
            rootView.addProgress(progressStep * Float(photoVideoManager.selectedScreenshotsForSmartCleaning.count))
            photoVideoManager.selectedScreenshotsForSmartCleaning.removeAll()
            dispatchGroup.leave()
        } else {
            rootView.addProgress(progressStep * Float(photoVideoManager.selectedScreenshotsForSmartCleaning.count))
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        if photoVideoManager.delete(assets: photoVideoManager.selectedVideosForSmartCleaning) {
            rootView.addProgress(progressStep * Float(photoVideoManager.selectedVideosForSmartCleaning.count))
            photoVideoManager.selectedVideosForSmartCleaning.removeAll()
            dispatchGroup.leave()
        } else {
            rootView.addProgress(progressStep * Float(photoVideoManager.selectedVideosForSmartCleaning.count))
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        if contactManager.delete(contactManager.selectedContactsForSmartCleaning) {
            rootView.addProgress(progressStep * Float(contactManager.selectedContactsForSmartCleaning.count))
            contactManager.selectedContactsForSmartCleaning.removeAll()
            dispatchGroup.leave()
        } else {
            rootView.addProgress(progressStep * Float(contactManager.selectedContactsForSmartCleaning.count))
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        if calendarManager.delete(calendarManager.selectedEventsForSmartCleaning) {
            rootView.addProgress(progressStep * Float(calendarManager.selectedEventsForSmartCleaning.count))
            calendarManager.selectedEventsForSmartCleaning.removeAll()
            dispatchGroup.leave()
        } else {
            rootView.addProgress(progressStep * Float(calendarManager.selectedEventsForSmartCleaning.count))
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            let undeletedItemsCount = photoVideoManager.selectedPhotosForSmartCleaning.count +
            photoVideoManager.selectedScreenshotsForSmartCleaning.count +
            photoVideoManager.selectedVideosForSmartCleaning.count +
            calendarManager.selectedEventsForSmartCleaning.count +
            contactManager.selectedContactsForSmartCleaning.count
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self else { return }
                showCongratsView(deletedItemsCount: itemsForDeletion - undeletedItemsCount)
            }
        }
    }
}
