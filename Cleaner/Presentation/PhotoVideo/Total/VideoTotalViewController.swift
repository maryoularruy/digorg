//
//  VideoTotalViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 02.12.2024.
//

import UIKit

final class VideoTotalViewController: UIViewController {
    private lazy var rootView = VideoTotalView()
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
        tabBarController?.tabBar.isHidden = true
        setupUI()
    }
}

extension VideoTotalViewController: ViewControllerProtocol {
    func setupUI() {
        let progressStep: CGFloat = 1.0 / 3
        rootView.progressViewHeight.constant = ScanningGalleryProgressView.height
        rootView.progressView.resetProgress()
        let dispatchGroup = DispatchGroup()
        rootView.subviews.forEach { $0.isUserInteractionEnabled = false }
        
        dispatchGroup.enter()
        photoVideoManager.fetchSimilarVideos { [weak self] assetGroups, duplicatesCount, _ in
            guard let self else { return }
            rootView.duplicateVideosView.assets = photoVideoManager.join(assetGroups)
            rootView.duplicateVideosView.delegate = self
            
            rootView.progressView.progressBar.addProgress(progressStep)
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        photoVideoManager.fetchSuperSizedVideos { [weak self] videos in
            guard let self else { return }
            rootView.superSizedVideosView.assets = videos
            rootView.superSizedVideosView.delegate = self
            
            rootView.progressView.progressBar.addProgress(progressStep)
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        photoVideoManager.fetchAllVideos { [weak self] videos in
            guard let self else { return }
            rootView.allVideosView.assets = videos
            rootView.allVideosView.delegate = self
            
            rootView.progressView.progressBar.addProgress(progressStep)
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            rootView.subviews.forEach { $0.isUserInteractionEnabled = true }
            rootView.progressViewHeight.constant = 0
            UIView.animate(withDuration: 0.6) {
                self.rootView.progressView.layoutIfNeeded()
                self.rootView.containerForVisibleOneCategoryViews.layoutIfNeeded()
            }
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
        
        rootView.scroll.refreshControl = UIRefreshControl()
        rootView.scroll.refreshControl?.addTarget(self, action: #selector(updateUI), for: .valueChanged)
    }
    
    @objc private func updateUI() {
        setupUI()
        rootView.scroll.refreshControl?.endRefreshing()
    }
}

extension VideoTotalViewController: OneCategoryHorizontalViewDelegate {
    func tapOnCategory(_ type: OneCategory.HorizontalViewType) {
        let vc: UIViewController? = switch type {
        case .similarPhotos: nil
        case .duplicatePhotos: nil
        case .portraits: nil
        case .allPhotos: nil
        case .duplicateVideos:
            StoryboardScene.GroupedAssets.initialScene.instantiate()
        case .superSizedVideos:
            RegularAssetsViewController(type: .superSizedVideos)
        case .allVideos:
            RegularAssetsViewController(type: .allVideos)
        }
        
        if let vc {
            vc.modalPresentationStyle = .fullScreen
            if vc is GroupedAssetsViewController {
                (vc as! GroupedAssetsViewController).type = .duplicateVideos
            }
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
