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

final class GroupedAssetsViewController: UIViewController {
    @IBOutlet weak var similarPhotoLabel: Semibold24LabelStyle!
    @IBOutlet weak var duplicatesCountLabel: Regular13LabelStyle!
	@IBOutlet weak var arrowBackView: UIView!
    @IBOutlet weak var selectionButton: SelectionButtonStyle!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbar: ActionToolbar!
    
    lazy var type: GroupedAssetsType? = nil
    
    private lazy var photoVideoManager = PhotoVideoManager.shared
    
    private lazy var assetGroups = [PHAssetGroup]() {
        didSet {
            let allAssetsCount = assetGroups.reduce(0) { $0 + $1.assets.count }
            selectionButton.isClickable = !assetGroups.isEmpty
            duplicatesCountLabel.bind(text: "\(allAssetsCount) file\(allAssetsCount == 1 ? "" : "s")")
            
            if assetGroups.isEmpty {
                setupEmptyState()
            } else {
                selectionButton.bind(text: assetsForDeletion.count == allAssetsCount ? .deselectAll : .selectAll)
            }
        }
    }
    
    private lazy var duplicatesCount: Int = 0
    
    private lazy var assetsForDeletion = Set<PHAsset>() {
        didSet {
            let size = assetsForDeletion.reduce(0) { $0 + $1.imageSize }
            toolbar.toolbarButton.bind(backgroundColor: assetsForDeletion.isEmpty ? .paleBlue : .blue)
            toolbar.toolbarButton.bind(text: "Delete \(assetsForDeletion.count) Item\(assetsForDeletion.count == 1 ? "" : "s"), \(size.convertToString())")
            
            let allAssetsCount = assetGroups.reduce(0) { $0 + $1.assets.count }
            selectionButton.bind(text: assetsForDeletion.count == allAssetsCount ? .deselectAll : .selectAll)
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
	
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionButton.delegate = self
        toolbar.delegate = self
        guard let type else { return }
        similarPhotoLabel.text = type.title
        tableView.register(cellType: DuplicateTableViewCell.self)
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    private func setupEmptyState() {
        
    }
}

extension GroupedAssetsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		assetGroups.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(for: indexPath) as DuplicateTableViewCell
		cell.setupData(assets: assetGroups[indexPath.item].assets)
        cell.selectionStyle = .none
		cell.onTap = { [weak self] assets, index in
			guard let self = self else { return }
			let gallery = DKPhotoGallery()
			gallery.singleTapMode = .dismiss
			var dkarr = [DKPhotoGalleryItem]()
            assets.forEach { asset in
				dkarr.append(DKPhotoGalleryItem(asset: asset))
			}
			gallery.items = dkarr
			gallery.presentationIndex = index
			self.present(photoGallery: gallery)
		}
		cell.onTapCheckBox = { [weak self] index in
			guard let self else { return }
			if !self.assetsForDeletion.contains(self.assetGroups[indexPath.item].assets[index]) {
				self.assetsForDeletion.insert(self.assetGroups[indexPath.item].assets[index])
			} else {
				self.assetsForDeletion.remove(self.assetGroups[indexPath.item].assets[index])
			}
            cell.assetsForDeletion = self.assetsForDeletion
		}
		cell.onTapSelectAll = { [weak self] assets in
			guard let self else { return }
			assetsForDeletion.insert(assets)
			tableView.reloadData()
		}
        cell.assetsForDeletion = self.assetsForDeletion
		return cell
	}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
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
        guard let type else { return }
        assetGroups = switch type {
        case .similarPhotos:
            photoVideoManager.similarPhotos
        case .duplicatePhotos:
            photoVideoManager.similarPhotos
        case .duplicateVideos:
            photoVideoManager.similarVideos
        }
        assetsForDeletion = []
    }
}

extension GroupedAssetsViewController: SelectionButtonDelegate {
    func tapOnButton() {
        tableView.reloadData()
    }
}

extension GroupedAssetsViewController: ActionToolbarDelegate {
    func tapOnActionButton() {
        deletePhotos()
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
                self?.refreshUI(assetGroups: assetGroups)
            }
        } else {
            PhotoVideoManager.shared.fetchSimilarPhotos(live: false) { [weak self] assetGroups, _, _ in
                self?.refreshUI(assetGroups: assetGroups)
            }
        }
    }
    
    private func refreshUI(assetGroups: [PHAssetGroup]) {
        self.assetGroups = assetGroups
        setupUI()
        tableView.reloadData()
    }
}
