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

enum RegularAssetsEntryFrom {
    case smartClean, assetsCleanMenu
}

final class RegularAssetsViewController: UIViewController {
    private var type: RegularAssetsType
    lazy var from: RegularAssetsEntryFrom = .assetsCleanMenu
    
    private lazy var rootView = RegularAssetsView(type)
    private lazy var photoVideoManager = PhotoVideoManager.shared

    private lazy var assets: [PHAsset] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                rootView.assetsCountLabel.bind(text: "\(assets.count) file\(assets.count == 1 ? "" : "s")")
                rootView.selectionButton.isClickable = !assets.isEmpty
                rootView.assetsCollectionView.reloadData()
                if assets.isEmpty {
                    setupEmptyState()
                } else {
                    rootView.selectionButton.bind(text: assetsForDeletion.count == assets.count ? .deselectAll : .selectAll)
                    
                    switch from {
                    case .smartClean:
                        rootView.toolbar.toolbarButton.bind(text: "Apply")
                        rootView.toolbar.toolbarButton.isClickable = true
                    case .assetsCleanMenu:
                        rootView.toolbar.toolbarButton.bind(text: "Delete \(assetsForDeletion.count) Item\(assetsForDeletion.count == 1 ? "" : "s")")
                        rootView.toolbar.toolbarButton.isClickable = !assetsForDeletion.isEmpty
                    }

                    emptyStateView = nil
                }
            }
        }
    }
    
    private lazy var assetsForDeletion = Set<PHAsset>() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                rootView.selectionButton.bind(text: assetsForDeletion.count == assets.count ? .deselectAll : .selectAll)
                
                switch from {
                case .smartClean:
                    rootView.toolbar.toolbarButton.bind(text: "Apply")
                    rootView.toolbar.toolbarButton.isClickable = true
                case .assetsCleanMenu:
                    rootView.toolbar.toolbarButton.bind(text: "Delete \(assetsForDeletion.count) Item\(assetsForDeletion.count == 1 ? "" : "s")")
                    rootView.toolbar.toolbarButton.isClickable = !assetsForDeletion.isEmpty
                }
                
                rootView.assetsCollectionView.reloadData()
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
        setupSort()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    private func setupEmptyState() {
        rootView.selectionButton.bind(text: .selectAll)
        
        switch from {
        case .smartClean:
            rootView.toolbar.toolbarButton.bind(text: "Apply")
        case .assetsCleanMenu:
            rootView.toolbar.toolbarButton.bind(text: "Back")
        }
        
        rootView.toolbar.toolbarButton.isClickable = true
        emptyStateView?.removeFromSuperview()
        emptyStateView = rootView.createEmptyState(type: .empty)
        if let emptyStateView {
            rootView.addSubview(emptyStateView)
        }
        rootView.layoutIfNeeded()
    }
    
    private func reloadData(isFirstResponder: Bool = true) {
        switch type {
        case .livePhotos:
            photoVideoManager.fetchLivePhotos { [weak self] assets in
                guard let self else { return }
                var unsortedAssets = assets
                photoVideoManager.sort(&unsortedAssets, type: rootView.sortButton.type ?? .latest)
                self.assets = unsortedAssets
                assetsForDeletion.insert(isFirstResponder ? self.assets : [])
            }
        case .blurryPhotos:
            photoVideoManager.fetchBlurryPhotos { [weak self] assets in
                guard let self else { return }
                var unsortedAssets = assets
                photoVideoManager.sort(&unsortedAssets, type: rootView.sortButton.type ?? .latest)
                self.assets = unsortedAssets
                assetsForDeletion.insert(isFirstResponder ? self.assets : [])
            }
        case .portraits:
            photoVideoManager.fetchSelfiePhotos { [weak self] assets in
                guard let self else { return }
                var unsortedAssets = assets
                photoVideoManager.sort(&unsortedAssets, type: rootView.sortButton.type ?? .latest)
                self.assets = unsortedAssets
                assetsForDeletion.insert(isFirstResponder ? self.assets : [])
            }
        case .screenshots:
            
            photoVideoManager.fetchScreenshots { [weak self] assets in
                guard let self else { return }
                var unsortedAssets = assets
                photoVideoManager.sort(&unsortedAssets, type: rootView.sortButton.type ?? .latest)
                self.assets = unsortedAssets
                assetsForDeletion.insert(isFirstResponder ? self.assets : [])
            }
            
            if from == .smartClean {
                assetsForDeletion.insert(photoVideoManager.selectedScreenshotsForSmartCleaning)
            }
            
        case .allPhotos:
            photoVideoManager.fetchAllPhotos { [weak self] assets in
                guard let self else { return }
                var unsortedAssets = assets
                photoVideoManager.sort(&unsortedAssets, type: rootView.sortButton.type ?? .latest)
                self.assets = unsortedAssets
                assetsForDeletion.insert(isFirstResponder ? self.assets : [])
            }
        case .superSizedVideos:
            photoVideoManager.fetchSuperSizedVideos { [weak self] assets in
                guard let self else { return }
                var unsortedAssets = assets
                photoVideoManager.sort(&unsortedAssets, type: rootView.sortButton.type ?? .latest)
                self.assets = unsortedAssets
                assetsForDeletion.insert(isFirstResponder ? self.assets : [])
            }
        case .allVideos:
            photoVideoManager.fetchAllVideos { [weak self] assets in
                guard let self else { return }
                var unsortedAssets = assets
                photoVideoManager.sort(&unsortedAssets, type: rootView.sortButton.type ?? .latest)
                self.assets = unsortedAssets
                assetsForDeletion.insert(isFirstResponder ? self.assets : [])
            }
        }
    }
}

extension RegularAssetsViewController: ViewControllerProtocol {
    func setupUI() {
        rootView.assetsCollectionView.delegate = self
        rootView.assetsCollectionView.dataSource = self
        rootView.selectionButton.delegate = self
        rootView.toolbar.delegate = self
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

extension RegularAssetsViewController: SelectionButtonDelegate {
    func tapOnButton() {
        if assetsForDeletion.count == assets.count {
            assetsForDeletion.removeAll()
        } else {
            assetsForDeletion.insert(assets)
        }
    }
}

extension RegularAssetsViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(actionProvider: { [weak self] _ in
            guard let self else { return nil }
            return UIMenu(children: getSortMenuElements())
        })
    }
    
    private func setupSort() {
        let menu = UIMenu(options: UIMenu.Options.displayInline, children: getSortMenuElements())
        rootView.sortButton.showsMenuAsPrimaryAction = true
        rootView.sortButton.menu = menu
    }
    
    private func getSortMenuElements() -> [UIMenuElement] {
        let latest = UIAction(title: SortType.latest.title) { [weak self] _ in
            guard let self else { return }
            photoVideoManager.sort(&assets, type: .latest)
            rootView.sortButton.bind(type: .latest)
            rootView.assetsCollectionView.reloadData()
        }
        let oldest = UIAction(title: SortType.oldest.title) { [weak self] _ in
            guard let self else { return }
            photoVideoManager.sort(&assets, type: .oldest)
            rootView.sortButton.bind(type: .oldest)
            rootView.assetsCollectionView.reloadData()
        }
        let largest = UIAction(title: SortType.largest.title) { [weak self] _ in
            guard let self else { return }
            photoVideoManager.sort(&assets, type: .largest)
            rootView.sortButton.bind(type: .largest)
            rootView.assetsCollectionView.reloadData()
        }
        return [latest, oldest, largest]
    }
}

extension RegularAssetsViewController: ActionToolbarDelegate {
    func tapOnActionButton() {
        switch from {
        case .smartClean:
            photoVideoManager.selectedScreenshotsForSmartCleaning = Array(assetsForDeletion)
            navigationController?.popViewController(animated: true)
            
        case .assetsCleanMenu:
            if assets.isEmpty {
                navigationController?.popViewController(animated: true)
            } else {
                if photoVideoManager.delete(assets: Array(assetsForDeletion)) {
                    let vc = CleaningAssetsViewController(from: .regularAssets, itemsCount: assetsForDeletion.count)
                    vc.modalPresentationStyle = .currentContext
                    navigationController?.pushViewController(vc, animated: false)
                    assetsForDeletion.removeAll()
                    reloadData(isFirstResponder: false)
                }
            }
        }
    }
}

extension RegularAssetsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AssetCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let item = assets[indexPath.row]
        cell.photoImageView.image = item.getAssetThumbnail(TargetSize.medium.size)
        cell.isChecked = assetsForDeletion.contains(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AssetCollectionViewCell else { return }
        cell.isChecked.toggle()
        if cell.isChecked {
            assetsForDeletion.remove(assets[indexPath.row])
        } else {
            assetsForDeletion.insert(assets[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let oneSideSize = (rootView.assetsCollectionView.frame.width / RegularAssetsView.assetsInRow) - RegularAssetsView.spacingBetweenAssets
        return CGSize(width: oneSideSize, height: oneSideSize)
    }
}
