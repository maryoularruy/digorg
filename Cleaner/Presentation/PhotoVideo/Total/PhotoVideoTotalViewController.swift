//
//  PhotoVideoTotalViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.11.2024.
//

import UIKit
import Photos

final class PhotoVideoTotalViewController: UIViewController {
    private lazy var rootView = PhotoVideoTotalView()
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
        updatePhotosCleanupOption()
    }
    
    private func updatePhotosCleanupOption() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.photoVideoManager.loadSimilarPhotos(live: false) { assetGroups, duplicatesCount in
                var assets: [PHAsset] = []
                assetGroups.forEach { group in
                    assets.append(contentsOf: group.assets)
                }
                DispatchQueue.main.async {
                    self?.rootView.similarPhotosView.assets = assets
                }
            }
        }
    }
}

extension PhotoVideoTotalViewController: ViewControllerProtocol {
    func setupUI() {}
    
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
