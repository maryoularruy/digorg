//
//  PhotoTotalViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.11.2024.
//

import UIKit
import Photos

final class PhotoTotalViewController: UIViewController {
    private lazy var rootView = PhotoTotalView()
    private lazy var photoVideoManager = PhotoVideoManager.shared
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    private func setupScanning() {
        rootView.subviews.forEach { $0.isUserInteractionEnabled = false }
        showProgressBar()
    }
    
    private func showProgressBar() {
        
    }
}

extension PhotoTotalViewController: ViewControllerProtocol {
    func setupUI() {
//        if photoVideoManager.isLoadingPhotos {
//            rootView.similarPhotosView.assets = []
//            rootView.duplicatePhotosView.assets = []
//            setupScanning()
//        } else {
//            rootView.subviews.forEach { $0.isUserInteractionEnabled = true }
//            rootView.similarPhotosView.assets = photoVideoManager.join(photoVideoManager.similarPhotos)
//            rootView.duplicatePhotosView.assets = photoVideoManager.join(photoVideoManager.similarPhotos)
//        }
        
        photoVideoManager.fetchSimilarPhotos(live: false) { [weak self] assetGroups, duplicatesCount in
            guard let self else { return }
            let joinedAssets = photoVideoManager.join(assetGroups)
            rootView.similarPhotosView.assets = joinedAssets
            rootView.duplicatePhotosView.assets = joinedAssets
            
            rootView.similarPhotosView.delegate = self
            rootView.duplicatePhotosView.delegate = self
        }
        
        photoVideoManager.fetchSelfiePhotos { [weak self] selfies in
            self?.rootView.portraitsPhotosView.assets = selfies
            self?.rootView.portraitsPhotosView.delegate = self
        }
        
        photoVideoManager.fetchAllPhotos { [weak self] photos in
            self?.rootView.allPhotosView.assets = photos
            self?.rootView.allPhotosView.delegate = self
        }
        
        photoVideoManager.fetchLivePhotos { [weak self] livePhotos in
            self?.rootView.livePhotosView.assets = livePhotos
            self?.rootView.livePhotosView.delegate = self
        }
        
        photoVideoManager.fetchBlurryPhotos { [weak self] blurries in
            self?.rootView.blurryPhotosView.assets = blurries
            self?.rootView.blurryPhotosView.delegate = self
        }
        
        photoVideoManager.loadScreenshotPhotos { [weak self] screenshots in
            self?.rootView.screenshotsView.assets = screenshots
            self?.rootView.screenshotsView.delegate = self
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
    
    @objc private func handleSwipeRight() {
        navigationController?.popViewController(animated: true)
    }
}

extension PhotoTotalViewController: OneCategoryHorizontalViewDelegate, OneCategoryRectangularViewDelegate, OneCategoryVerticalViewDelegate {
    func tapOnCategory(_ type: OneCategoryVerticalViewType) {
        let vc: UIViewController = switch type {
        case .screenshots:
            RegularAssetsViewController(type: .screenshots)
        }
        
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tapOnCategory(_ type: OneCategoryRectangularViewType) {
        let vc: UIViewController = switch type {
        case .live:
            RegularAssetsViewController(type: .livePhotos)
        case .blurry:
            RegularAssetsViewController(type: .blurryPhotos)
        }
        
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tapOnCategory(_ type: OneCategoryHorizontalViewType) {
        let vc: UIViewController? = switch type {
        case .similarPhotos:
            StoryboardScene.GroupedAssets.initialScene.instantiate()
        case .duplicatePhotos:
            StoryboardScene.GroupedAssets.initialScene.instantiate()
        case .portraits:
            RegularAssetsViewController(type: .portraits)
        case .allPhotos:
            RegularAssetsViewController(type: .allPhotos)
        case .duplicateVideos: nil
        case .superSizedVideos: nil
        case .allVideos: nil
        }
        
        if let vc {
            vc.modalPresentationStyle = .fullScreen
            if vc is GroupedAssetsViewController {
                (vc as! GroupedAssetsViewController).type = .similarPhotos
            }
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
