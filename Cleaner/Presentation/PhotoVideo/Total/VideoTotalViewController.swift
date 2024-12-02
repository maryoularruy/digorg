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
        setupUI()
    }
}

extension VideoTotalViewController: ViewControllerProtocol {
    func setupUI() {
        photoVideoManager.fetchSimilarVideos { [weak self] assetGroups, duplicatesCount in
            guard let self else { return }
            rootView.duplicateVideosView.assets = photoVideoManager.join(assetGroups)
            rootView.duplicateVideosView.delegate = self
        }
        
        photoVideoManager.fetchSuperSizedVideos { [weak self] videos in
            self?.rootView.superSizedVideosView.assets = videos
        }
        
        photoVideoManager.fetchAllVideos { [weak self] videos in
            self?.rootView.allVideosView.assets = videos
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

extension VideoTotalViewController: OneCategoryHorizontalViewDelegate {
    func tapOnCategory(_ type: OneCategoryHorizontalViewType) {
        let vc: UIViewController? = switch type {
        case .similarPhotos: nil
        case .duplicatePhotos: nil
        case .portraits: nil
        case .allPhotos: nil
        case .duplicateVideos: StoryboardScene.GroupedAssets.initialScene.instantiate()
        case .superSizedVideos: StoryboardScene.GroupedAssets.initialScene.instantiate()
        case .allVideos: StoryboardScene.GroupedAssets.initialScene.instantiate()
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
