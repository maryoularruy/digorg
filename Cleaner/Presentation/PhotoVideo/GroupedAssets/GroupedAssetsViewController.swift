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
    @IBOutlet weak var similarPhotoLabel: UILabelSubtitleStyle!
    @IBOutlet weak var duplicatesCountLabel: UILabelSubhealine13sizeStyle!
    @IBOutlet var deletionButton: UIButton!
	@IBOutlet var arrowBackView: UIView!
	@IBOutlet var selectLabel: UILabel!
	@IBOutlet var tableView: UITableView!
	lazy var assetGroups = [PHAssetGroup]()
    lazy var duplicatesCount: Int = 0
	lazy var assetsForDeletion = Set<PHAsset>()
	var assetsInput: [PHAssetGroup] {
		get { return assetGroups }
		set {
			let changeset = StagedChangeset(source: assetGroups, target: newValue)
			tableView.reload(using: changeset, with: .fade) { [weak self] data in
				guard let self = self else { return }
				self.assetGroups = data
			} completion: {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
					guard let self = self else { return }
					self.tableView.reloadData()
				})
			}
		}
	}
	var selectMode = false {
		didSet {
			if selectMode {
				selectLabel.text = "Done"
			} else {
				selectLabel.text = "Select"
				assetsForDeletion.removeAll()
				deletionButton.isHidden = true
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
        setupUI()
        
		tableView.register(cellType: DuplicateTableViewCell.self)
		
		selectLabel.addTapGestureRecognizer { [weak self] in
			guard let self = self else { return }
			self.selectMode.toggle()
			self.tableView.reloadData()
		}
		updatePlaceholder()
        addGestureRecognizers()
	}
	
	@IBAction func deletePhotos(_ sender: Any) {
		if delete(assets: Array(assetsForDeletion)) {
			self.deletionButton.isHidden = true
			self.assetsInput = self.assetsInput.map ( { group in
				let tempGroup = group
				let notDeleted = tempGroup.assets.filter({ !assetsForDeletion.contains($0)})
				tempGroup.assets = notDeleted
				return tempGroup
			})
			self.assetsInput = self.assetsInput.filter({ $0.assets.count != 0 })
			self.assetsForDeletion.removeAll()
			self.selectMode = false
			
			updatePlaceholder()
		}
	}
	
	func delete(assets: [PHAsset]) -> Bool {
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
		if semaphoreResult == .success {
			return result
		} else {
			return false
		}
	}
}

extension GroupedAssetsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return assetGroups.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(for: indexPath) as DuplicateTableViewCell
		cell.setupData(assets: assetGroups[indexPath.item].assets)
		cell.setupSelectMode(isON: selectMode)
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
			guard let self = self else { return }
			if !self.assetsForDeletion.contains(self.assetGroups[indexPath.item].assets[index]) {
				self.assetsForDeletion.insert(self.assetGroups[indexPath.item].assets[index])
			} else {
				self.assetsForDeletion.remove(self.assetGroups[indexPath.item].assets[index])
			}
			
			if self.assetsForDeletion.isEmpty {
				self.deletionButton.isHidden = true
			} else {
				self.deletionButton.isHidden = false
				self.deletionButton.setTitle("Delete \(self.assetsForDeletion.count) photos", for: .normal)
			}
		}
		cell.onTapSelectAll = { [weak self] assets in
			guard let self = self else { return }
			self.selectMode = true
			self.assetsForDeletion.insert(assets) //= Set(assets)
			self.deletionButton.isHidden = false
			self.deletionButton.setTitle("Delete \(self.assetsForDeletion.count) photos", for: .normal)
			self.tableView.reloadData()
		}
		cell.assetsForDeletion = self.assetsForDeletion
		return cell
	}
}

extension GroupedAssetsViewController: ViewControllerProtocol {
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }
    }
    
    func setupUI() {
        similarPhotoLabel.text = "Similar Photo"
        duplicatesCountLabel.text = "\(duplicatesCount) files"
        updatePlaceholder()
    }
    
    private func updatePlaceholder() {
        if assetGroups.isEmpty {
            self.deletionButton.isHidden = false
            self.selectLabel.isHidden = true
        }
    }
}
