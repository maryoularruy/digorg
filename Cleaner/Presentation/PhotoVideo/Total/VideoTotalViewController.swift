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
