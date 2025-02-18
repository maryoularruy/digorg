//
//  DuplicatePhotoViewController.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 27.05.2022.
//

import Photos
import UIKit

enum GroupedAssetsType {
    case similarPhotos, duplicatePhotos, duplicateVideos
    
    var title: String {
        switch self {
        case .similarPhotos: "Similar Photos"
        case .duplicatePhotos: "Duplicate Photos"
        case .duplicateVideos: "Duplicate Videos"
        }
    }
}

enum GroupedAssetsEntryFrom {
    case smartClean, assetsCleanMenu
}

final class GroupedAssetsViewController: UIViewController {
    @IBOutlet weak var similarPhotoLabel: Semibold24LabelStyle!
    @IBOutlet weak var duplicatesCountLabel: Regular13LabelStyle!
	@IBOutlet weak var arrowBackView: UIView!
    @IBOutlet weak var selectionButton: SelectionButtonStyle!
    @IBOutlet weak var sortButton: SortButtonStyle!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbar: ActionToolbar!
    
    lazy var type: GroupedAssetsType? = nil
    lazy var from: GroupedAssetsEntryFrom = .assetsCleanMenu
    
    private lazy var photoVideoManager = PhotoVideoManager.shared
    
    private lazy var assetGroups = [PHAssetGroup]() {
        didSet {
            selectionButton.isClickable = !assetGroups.isEmpty
            duplicatesCountLabel.bind(text: "\(assetsCount) file\(assetsCount == 1 ? "" : "s")")
            
            if assetGroups.isEmpty {
                setupEmptyState()
            } else {
                selectionButton.bind(text: assetsForDeletion.count == assetsCount ? .deselectAll : .selectAll)
                
                switch from {
                case .smartClean:
                    toolbar.toolbarButton.bind(text: "Apply")
                    toolbar.toolbarButton.isClickable = true
                case .assetsCleanMenu:
                    let size = assetsForDeletion.reduce(0) { $0 + $1.imageSize }
                    toolbar.toolbarButton.bind(text: "Delete \(assetsForDeletion.count) Item\(assetsForDeletion.count == 1 ? "" : "s"), \(size.convertToString())")
                    toolbar.toolbarButton.isClickable = !assetsForDeletion.isEmpty
                }
                
                emptyStateView = nil
            }
        }
    }
    
    private var assetsCount: Int {
        assetGroups.reduce(0) { $0 + $1.assets.count }
    }
    
    private lazy var assetsForDeletion = Set<PHAsset>() {
        didSet {
            selectionButton.bind(text: assetsForDeletion.count == assetsCount ? .deselectAll : .selectAll)
            
            switch from {
            case .smartClean:
                toolbar.toolbarButton.bind(text: "Apply")
                toolbar.toolbarButton.isClickable = true
            case .assetsCleanMenu:
                let size = assetsForDeletion.reduce(0) { $0 + $1.imageSize }
                toolbar.toolbarButton.bind(text: "Delete \(assetsForDeletion.count) Item\(assetsForDeletion.count == 1 ? "" : "s"), \(size.convertToString())")
                toolbar.toolbarButton.isClickable = !assetsForDeletion.isEmpty
            }
        }
    }
    
	private var assetsInput: [PHAssetGroup] {
		get { assetGroups }
		set {
			let changeset = StagedChangeset(source: assetGroups, target: newValue)
			tableView.reload(using: changeset, with: .fade) { [weak self] data in
				guard let self else { return }
				assetGroups = data
			} completion: {
				DispatchQueue.main.async { [weak self] in
					guard let self else { return }
					tableView.reloadData()
				}
			}
		}
	}
    
    private lazy var emptyStateView: EmptyStateView? = nil
	
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    private func reloadData() {
        guard let type else { return }
        var groups = switch type {
        case .similarPhotos:
            photoVideoManager.similarPhotos
        case .duplicatePhotos:
            photoVideoManager.similarPhotos
        case .duplicateVideos:
            photoVideoManager.similarVideos
        }
        photoVideoManager.sort(&groups, type: sortButton.type ?? .latest)
        assetGroups = groups
        
        if from == .smartClean {
            switch type {
            case .similarPhotos:
                assetsForDeletion.insert(photoVideoManager.selectedPhotosForSmartCleaning)
            case .duplicatePhotos:
                assetsForDeletion.insert(photoVideoManager.selectedPhotosForSmartCleaning)
            case .duplicateVideos:
                assetsForDeletion.insert(photoVideoManager.selectedVideosForSmartCleaning)
            }
        } else {
            assetsForDeletion = []
        }
    }
    
    private func setupEmptyState() {
        selectionButton.bind(text: .selectAll)
        
        switch from {
        case .smartClean:
            toolbar.toolbarButton.bind(text: "Apply")
        case .assetsCleanMenu:
            toolbar.toolbarButton.bind(text: "Back")
        }
        
        toolbar.toolbarButton.isClickable = true
        emptyStateView?.removeFromSuperview()
        emptyStateView = view.createEmptyState(type: .empty)
        if let emptyStateView {
            view.addSubview(emptyStateView)
        }
        view.layoutIfNeeded()
    }
    
    private func isContainsForDeletion(assets: [PHAsset]) -> Bool {
        var isContains = true
        for i in 0..<assets.count {
            if !assetsForDeletion.contains(assets[i]) {
                isContains = false
                break
            }
        }
        return isContains
    }
}

extension GroupedAssetsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		assetGroups.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(for: indexPath) as DuplicateTableViewCell
        cell.delegate = self
        cell.index = indexPath.item
        cell.bind(assets: assetGroups[indexPath.item].assets)
//		cell.onTapSelectAll = { [weak self] assets in
//			guard let self else { return }
//            if isContainsForDeletion(assets: assets) {
//                assets.forEach { [weak self] in self?.assetsForDeletion.remove($0) }
//            } else {
//                assetsForDeletion.insert(assets)
//            }
//            tableView.reloadRows(at: [indexPath], with: .none)
//		}
        cell.selectAllButton.bind(text: isContainsForDeletion(assets: assetGroups[indexPath.item].assets) ? .deselectAll : .selectAll)
        cell.assetsForDeletion = assetsForDeletion
        
		return cell
	}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension GroupedAssetsViewController: DuplicateTableViewCellDelegate {
    func tapOnCell(assets: [PHAsset], currentPosition: Int) {
        let carousel = MediaCarousel()
        carousel.singleTapMode = .dismiss
        var items = [MediaCarouselItem]()
        assets.forEach { asset in
            items.append(MediaCarouselItem(asset: asset))
        }
        carousel.items = items
        carousel.presentationIndex = currentPosition
        present(photoGallery: carousel)
    }
    
    func tapOnCheckBox(groupIndex: Int, assetIndex: Int) {
        let asset = assetGroups[groupIndex].assets[assetIndex]
        if !assetsForDeletion.contains(asset) {
            assetsForDeletion.insert(asset)
        } else {
            assetsForDeletion.remove(asset)
        }
        tableView.reloadRows(at: [IndexPath(row: groupIndex, section: 0)], with: .none)
    }
}

extension GroupedAssetsViewController: ViewControllerProtocol {
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }
    
    func setupUI() {
        tableView.register(cellType: DuplicateTableViewCell.self)
        selectionButton.delegate = self
        toolbar.delegate = self
        setupSort()
        guard let type else { return }
        similarPhotoLabel.text = type.title
    }
}

extension GroupedAssetsViewController: SelectionButtonDelegate {
    func tapOnButton() {
        let allAssetsCount = assetGroups.reduce(0) { $0 + $1.assets.count }
        if allAssetsCount == assetsForDeletion.count {
            assetsForDeletion.removeAll()
        } else {
            assetGroups.forEach { assetsForDeletion.insert($0.assets) }
        }
        tableView.reloadData()
    }
}

extension GroupedAssetsViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(actionProvider: { [weak self] _ in
            guard let self else { return nil }
            return UIMenu(children: getSortMenuElements())
        })
    }
    
    private func setupSort() {
        let menu = UIMenu(options: UIMenu.Options.displayInline, children: getSortMenuElements())
        sortButton.showsMenuAsPrimaryAction = true
        sortButton.menu = menu
    }
    
    private func getSortMenuElements() -> [UIMenuElement] {
        let latest = UIAction(title: SortType.latest.title) { [weak self] _ in
            guard let self else { return }
            photoVideoManager.sort(&assetGroups, type: .latest)
            sortButton.bind(type: .latest)
            tableView.reloadData()
        }
        let oldest = UIAction(title: SortType.oldest.title) { [weak self] _ in
            guard let self else { return }
            photoVideoManager.sort(&assetGroups, type: .oldest)
            sortButton.bind(type: .oldest)
            tableView.reloadData()
        }
        let largest = UIAction(title: SortType.largest.title) { [weak self] _ in
            guard let self else { return }
            photoVideoManager.sort(&assetGroups, type: .largest)
            sortButton.bind(type: .largest)
            tableView.reloadData()
        }
        return [latest, oldest, largest]
    }
}

extension GroupedAssetsViewController: ActionToolbarDelegate {
    func tapOnActionButton() {
        switch from {
        case .smartClean:
            switch type {
            case .similarPhotos:
                photoVideoManager.selectedPhotosForSmartCleaning = Array(assetsForDeletion)
            case .duplicatePhotos:
                photoVideoManager.selectedPhotosForSmartCleaning = Array(assetsForDeletion)
            case .duplicateVideos:
                photoVideoManager.selectedVideosForSmartCleaning = Array(assetsForDeletion)
            case .none:
                break
            }                
            navigationController?.popViewController(animated: true)
            
        case .assetsCleanMenu:
            if assetsForDeletion.isEmpty {
                navigationController?.popViewController(animated: true)
            } else {
                deletePhotos()
            }
        }
    }
    
    private func deletePhotos() {
        if photoVideoManager.delete(assets: Array(assetsForDeletion)) {
            assetsInput = assetsInput.map { group in
                var tempGroup = group
                let notDeleted = tempGroup.assets.filter { !assetsForDeletion.contains($0) }
                tempGroup.assets = notDeleted
                return tempGroup
            }
            assetsInput = assetsInput.filter { $0.assets.count != 0 }
            assetsForDeletion.removeAll()
            refreshSimilarItems()
        }
    }
    
    @objc func refreshSimilarItems() {
        if assetGroups.first?.subtype == .smartAlbumVideos {
            PhotoVideoManager.shared.fetchSimilarVideos { [weak self] assetGroups, _, _ in
                var groups = assetGroups
                self?.photoVideoManager.sort(&groups, type: self?.sortButton.type ?? .latest)
                self?.assetGroups = groups
                self?.refreshUI(assetGroups: assetGroups)
            }
        } else {
            PhotoVideoManager.shared.fetchSimilarPhotos(live: false) { [weak self] assetGroups, _, _ in
                var groups = assetGroups
                self?.photoVideoManager.sort(&groups, type: self?.sortButton.type ?? .latest)
                self?.assetGroups = groups
                self?.refreshUI(assetGroups: assetGroups)
            }
        }
    }
    
    private func refreshUI(assetGroups: [PHAssetGroup]) {
        self.assetGroups = assetGroups
        reloadData()
        tableView.reloadData()
    }
}
