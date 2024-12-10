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
}

extension PhotoTotalViewController: ViewControllerProtocol {
    func setupUI() {
        let progressStep: CGFloat = 1.0 / 6
        rootView.progressBar.updateProgress(to: 0)
        let dispatchGroup = DispatchGroup()
        rootView.subviews.forEach { $0.isUserInteractionEnabled = false }
        
        dispatchGroup.enter()
        photoVideoManager.fetchSimilarPhotos(live: false) { [weak self] assetGroups, duplicatesCount in
            guard let self else { return }
            let joinedAssets = photoVideoManager.join(assetGroups)
            rootView.similarPhotosView.assets = joinedAssets
            rootView.duplicatePhotosView.assets = joinedAssets
            
            rootView.similarPhotosView.delegate = self
            rootView.duplicatePhotosView.delegate = self
            
            rootView.progressBar.addProgress(progressStep)
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        photoVideoManager.fetchSelfiePhotos { [weak self] selfies in
            guard let self else { return }
            rootView.portraitsPhotosView.assets = selfies
            rootView.portraitsPhotosView.delegate = self
            
            rootView.progressBar.addProgress(progressStep)
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        photoVideoManager.fetchAllPhotos { [weak self] photos in
            guard let self else { return }
            rootView.allPhotosView.assets = photos
            rootView.allPhotosView.delegate = self
            
            rootView.progressBar.addProgress(progressStep)
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        photoVideoManager.fetchLivePhotos { [weak self] livePhotos in
            guard let self else { return }
            rootView.livePhotosView.assets = livePhotos
            rootView.livePhotosView.delegate = self
            
            rootView.progressBar.addProgress(progressStep)
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        photoVideoManager.fetchBlurryPhotos { [weak self] blurries in
            guard let self else { return }
            rootView.blurryPhotosView.assets = blurries
            rootView.blurryPhotosView.delegate = self
            
            rootView.progressBar.addProgress(progressStep)
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        photoVideoManager.fetchScreenshots { [weak self] screenshots in
            guard let self else { return }
            rootView.screenshotsView.assets = screenshots
            rootView.screenshotsView.delegate = self
            
            rootView.progressBar.addProgress(progressStep)
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            rootView.subviews.forEach { $0.isUserInteractionEnabled = true }
            rootView.constrainVisibleOneCategoryViews()
        }
    }
    
    func addGestureRecognizers() {
        rootView.arrowBack.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
        
        rootView.scroll.refreshControl?.addTarget(self, action: #selector(updateUI), for: .valueChanged)
    }
    
    @objc private func handleSwipeRight() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func updateUI() {
        setupUI()
        rootView.scroll.refreshControl?.endRefreshing()
    }
}

extension PhotoTotalViewController: OneCategoryHorizontalViewDelegate, OneCategoryRectangularViewDelegate, OneCategoryVerticalViewDelegate {
    func tapOnCategory(_ type: OneCategory.VerticalViewType) {
        let vc: UIViewController = switch type {
        case .screenshots:
            RegularAssetsViewController(type: .screenshots)
        }
        
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tapOnCategory(_ type: OneCategory.RectangularViewType) {
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
    
    func tapOnCategory(_ type: OneCategory.HorizontalViewType) {
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
