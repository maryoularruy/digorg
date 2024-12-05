//
//  RegularAssetsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 04.12.2024.
//

import UIKit
import Photos

enum RegularAssetsType {
    case livePhotos, blurryPhotos, portraits, screenshots, allPhotos, superSizedVideos, allVideos
    
    var title: String {
        switch self {
        case .livePhotos: "Live Photo"
        case .blurryPhotos: "Blurry"
        case .portraits: "Portraits"
        case .screenshots: "Screenshots"
        case .allPhotos: "All Photos"
        case .superSizedVideos: "Super-sized Video"
        case .allVideos: "All Videos"
        }
    }
}

final class RegularAssetsViewController: UIViewController {
    private var type: RegularAssetsType
    
    private lazy var rootView = RegularAssetsView(type)
    private lazy var photoVideoManager = PhotoVideoManager.shared

    private lazy var assets: [PHAsset] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                rootView.assetsCountLabel.bind(text: "\(assets.count) file\(assets.count == 1 ? "" : "s")")
                rootView.selectionButton.isClickable = !assets.isEmpty
                if assets.isEmpty {
                    setupEmptyState()
                } else {
                    rootView.selectionButton.bind(text: assetsForDeletion.count == assets.count ? .deselectAll : .selectAll)
                    hideEmptyState()
                }
            }
        }
    }
    
    private lazy var assetsForDeletion = Set<PHAsset>() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                rootView.selectionButton.bind(text: assetsForDeletion.count == assets.count ? .deselectAll : .selectAll)
            }
        }
    }
    
    private lazy var emptyStateView: EmptyStateView? = nil
    
    init(type: RegularAssetsType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func setupEmptyState() {
        rootView.selectionButton.bind(text: .selectAll)
        rootView.assetsCollectionView.isHidden = true
        emptyStateView?.removeFromSuperview()
        emptyStateView = rootView.createEmptyState(type: .empty)
        if let emptyStateView {
            rootView.addSubview(emptyStateView)
        }
    }
    
    private func hideEmptyState() {
        rootView.assetsCollectionView.isHidden = false
        rootView.assetsCollectionView.reloadData()
        emptyStateView?.removeFromSuperview()
        emptyStateView = nil
    }
}

extension RegularAssetsViewController: ViewControllerProtocol {
    func setupUI() {
        switch type {
        case .livePhotos:
            photoVideoManager.fetchLivePhotos { [weak self] assets in
                self?.assets = assets
                self?.assetsForDeletion.insert(assets)
            }
        case .blurryPhotos:
            photoVideoManager.fetchBlurryPhotos { [weak self] assets in
                self?.assets = assets
                self?.assetsForDeletion.insert(assets)

            }
        case .portraits:
            photoVideoManager.fetchSelfiePhotos { [weak self] assets in
                self?.assets = assets
                self?.assetsForDeletion.insert(assets)

            }
        case .screenshots:
            photoVideoManager.fetchScreenshots { [weak self] assets in
                self?.assets = assets
                self?.assetsForDeletion.insert(assets)

            }
        case .allPhotos:
            photoVideoManager.fetchAllPhotos { [weak self] assets in
                self?.assets = assets
//                self?.assetsForDeletion.insert(assets)
                self?.assetsForDeletion = []

            }
        case .superSizedVideos:
            photoVideoManager.fetchSuperSizedVideos { [weak self] assets in
                self?.assets = assets
                self?.assetsForDeletion.insert(assets)

            }
        case .allVideos:
            photoVideoManager.fetchAllVideos { [weak self] assets in
                self?.assets = assets
                self?.assetsForDeletion.insert(assets)

            }
        }
        
        rootView.assetsCollectionView.delegate = self
        rootView.assetsCollectionView.dataSource = self
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

extension RegularAssetsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AssetCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.photoImageView.image = assets[indexPath.row].getAssetThumbnail(TargetSize.medium.size)
        cell.isChecked = assetsForDeletion.contains(assets[indexPath.row])
        cell.addTapGestureRecognizer {
            cell.isChecked.toggle()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (rootView.assetsCollectionView.frame.width / RegularAssetsView.assetsInRow) - RegularAssetsView.spacingBetweenAssets
        return CGSize(width: size, height: size)
    }
}
