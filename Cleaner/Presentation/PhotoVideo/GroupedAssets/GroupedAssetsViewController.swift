//
//  DuplicatePhotoViewController.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 27.05.2022.
//

import Photos
import UIKit
import CryptoKit

final class GroupedAssetsViewController: UIViewController {
    @IBOutlet weak var similarPhotoLabel: Semibold24LabelStyle!
    @IBOutlet weak var duplicatesCountLabel: Regular13LabelStyle!
	@IBOutlet var arrowBackView: UIView!
    @IBOutlet weak var selectModeButton: SelectionButtonStyle!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var actionToolbar: ActionToolbar!
    
    lazy var assetGroups = [PHAssetGroup]()
    lazy var duplicatesCount: Int = 0
    lazy var assetsForDeletion = Set<PHAsset>() {
        didSet {
            actionToolbar.toolbarButton.bind(backgroundColor: assetsForDeletion.isEmpty ? .paleBlue : .blue)
            actionToolbar.toolbarButton.bind(
                text: "Delete \(assetsForDeletion.count) Item\(assetsForDeletion.count == 1 ? "" : "s"), \(assetsForDeletion.isEmpty ? "0" : "?") MB")
        }
    }
    
	var assetsInput: [PHAssetGroup] {
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
    
	lazy var selectMode = false {
		didSet {
            if selectMode {
                selectModeButton.bind(text: .deselect)
			} else {
                selectModeButton.bind(text: .select)
				assetsForDeletion.removeAll()
                tableView.reloadData()
			}
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        actionToolbar.delegate = self
        setupUI()
        tableView.register(cellType: DuplicateTableViewCell.self)
        addGestureRecognizers()
    }
}

extension GroupedAssetsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return assetGroups.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(for: indexPath) as DuplicateTableViewCell
		cell.setupData(assets: assetGroups[indexPath.item].assets)
        cell.selectMode = self.selectMode
		cell.onTap = { [weak self] image, index in
			guard let self = self else { return }
			let gallery = DKPhotoGallery()
			gallery.singleTapMode = .dismiss
			var dkarr = [DKPhotoGalleryItem]()
			image.forEach { asset in
				dkarr.append(DKPhotoGalleryItem(asset: asset))
			}
			gallery.items = dkarr
			gallery.presentationIndex = index
			self.present(photoGallery: gallery)
		}
		cell.onTapWithSelectMode = { [weak self] index in
			guard let self else { return }
			if !self.assetsForDeletion.contains(self.assetGroups[indexPath.item].assets[index]) {
				self.assetsForDeletion.insert(self.assetGroups[indexPath.item].assets[index])
			} else {
				self.assetsForDeletion.remove(self.assetGroups[indexPath.item].assets[index])
			}
            cell.assetsForDeletion = self.assetsForDeletion
		}
		cell.onTapSelectAll = { [weak self] assets in
			guard let self = self else { return }
			self.selectMode = true
			self.assetsForDeletion.insert(assets) //= Set(assets)
			self.tableView.reloadData()
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
            guard let self else { return }
            let viewControllers: [UIViewController] = navigationController!.viewControllers as [UIViewController]
            navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }
        
        selectModeButton.addTapGestureRecognizer { [weak self] in
            guard let self else { return }
            selectMode.toggle()
            tableView.reloadData()
        }
    }
    
    func setupUI() {
        similarPhotoLabel.text = "Similar \(assetGroups.first?.subtype == .smartAlbumVideos ? "videos" : "photos")"
        duplicatesCountLabel.text = "\(duplicatesCount) files"
        selectMode = false
        updatePlaceholder()
    }
    
    private func updatePlaceholder() {
        if assetGroups.isEmpty {
            self.selectModeButton.isHidden = true
        }
    }
}

extension GroupedAssetsViewController: ActionToolbarDelegate {
    func tapOnActionButton() {
        deletePhotos()
    }
    
    private func deletePhotos() {
        if delete(assets: Array(assetsForDeletion)) {
            assetsInput = assetsInput.map { group in
                var tempGroup = group
                let notDeleted = tempGroup.assets.filter { !assetsForDeletion.contains($0) }
                tempGroup.assets = notDeleted
                return tempGroup
            }
            assetsInput = assetsInput.filter { $0.assets.count != 0 }
            assetsForDeletion.removeAll()
            selectMode = false
            refreshSimilarItems()
            updatePlaceholder()
        }
    }
    
    private func delete(assets: [PHAsset]) -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var result = false
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(assets as NSArray)}, completionHandler: { success, _ in
                if success {
                    result = true
                }
            semaphore.signal()
        })
        let semaphoreResult = semaphore.wait(timeout: .distantFuture)
        return semaphoreResult == .success ? result : false
    }
    
    @objc func refreshSimilarItems() {
        if assetGroups.first?.subtype == .smartAlbumVideos {
            PhotoVideoManager.shared.loadSimilarVideos { [weak self] assetGroups, duplicatesCount in
                self?.refreshUI(assetGroups: assetGroups, duplicatesCount: duplicatesCount)
            }
        } else {
            PhotoVideoManager.shared.loadSimilarPhotos(live: false) { [weak self] assetGroups, duplicatesCount in
                self?.refreshUI(assetGroups: assetGroups, duplicatesCount: duplicatesCount)
            }
        }
    }
    
    private func refreshUI(assetGroups: [PHAssetGroup], duplicatesCount: Int) {
        self.assetGroups = assetGroups
        self.duplicatesCount = duplicatesCount
        setupUI()
        tableView.reloadData()
    }
}
