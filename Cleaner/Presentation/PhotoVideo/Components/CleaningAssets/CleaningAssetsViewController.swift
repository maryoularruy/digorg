//
//  CleaningAssetsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.12.2024.
//

import UIKit

enum CleaningAssetsEntryFrom {
    case smartClean, regularAssets, secureVault
}

final class CleaningAssetsViewController: UIViewController {
    private lazy var rootView = CleaningAssetsView()
    
    private var from: CleaningAssetsEntryFrom
    private var itemsCount: Int
    private var items: Any?
    
    private lazy var photoVideoManager = PhotoVideoManager.shared
    private lazy var contactManager = ContactManager.shared
    private lazy var calendarManager = CalendarManager.shared
    
    private lazy var secretFolderName = UserDefaultsService.shared.get(String.self, key: .secureVaultFolder) ?? "media"
    
    init(from: CleaningAssetsEntryFrom, itemsCount: Int, items: Any? = nil) {
        self.from = from
        self.itemsCount = itemsCount
        self.items = items
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
                showCongratsView(deletedItemsCount: itemsCount)
            }
            
        case .secureVault:
            startCleaningSecureVault()
        }
    }
    
    deinit {
        print("CleaningAssetsViewController deinit")
    }
    
    private func showCongratsView(deletedItemsCount: Int) {
        rootView.showCongratsView(deletedItemsCount: deletedItemsCount)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }
    }
    
    private func startSmartCleaning() {
        let progressStep: Float = 1.0 / Float(itemsCount)
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
                showCongratsView(deletedItemsCount: itemsCount - undeletedItemsCount)
            }
        }
    }
    
    private func startCleaningSecureVault() {
        guard let items = items as? [SecretItemModel] else { return }
        let progressStep: Float = 1.0 / Float(itemsCount)
        var undeletedItemsCount = 0
        rootView.resetProgress()
        
        items.forEach { item in
            switch item.mediaType {
            case .photo:
                guard let url = FileManager.default.getUrlForFile(fileName: item.id, folderName: secretFolderName) else { return }
                
                if FileManager.default.fileExists(atPath: url.path) {
                    do {
                        try FileManager.default.removeItem(at: url)
                    } catch {
                        undeletedItemsCount += 1
                    }
                }
                
            case .video:
                guard let url = item.videoUrl else { return }
                do {
                    try FileManager.default.removeItem(at: url)
                } catch {
                    undeletedItemsCount += 1
                }
            }
            rootView.addProgress(progressStep)
        }
        showCongratsView(deletedItemsCount: itemsCount - undeletedItemsCount)
    }
}
