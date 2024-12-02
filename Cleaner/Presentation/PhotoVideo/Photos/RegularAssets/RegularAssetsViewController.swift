//
//  ScreenshotViewController.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 23.05.2022.
//

import SDWebImagePhotosPlugin
import Photos
import UIKit

class RegularAssetsViewController: UIViewController {
	@IBOutlet var collectionView: UICollectionView!
	@IBOutlet var selectAllLabel: UILabel!
	var assets = [PHAsset]()
	var assetsForDeletion = Set<PHAsset>()
	var assetsInput: [PHAsset] {
		get { return assets }
		set {
			let changeset = StagedChangeset(source: assets, target: newValue)
			collectionView.reload(using: changeset) { [weak self] data in
				guard let self = self else { return }
				self.assets = data
			} completion: {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
					guard let self = self else { return }
					self.collectionView.reloadData()
				})
			}
		}
	}
	@IBOutlet var deletionButton: UIButton!
	@IBOutlet var arrowBackView: UIView!
	@IBOutlet var selectLabel: UILabel!
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
	@IBOutlet var placeholderLabel: UILabel!
	@IBOutlet var selectAllView: UIView!
	var transitionController: ZoomTransitionController?
	var currentIndexPath: IndexPath?
	var type: TypeOfAsset = .screen
	enum TypeOfAsset {
		case screen
		case selfie
		case gif
		case live
	}
	@IBOutlet var titleLabel: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupArraysOfAsset()
		setupImageManager()
		setupCollectionView()
		setSelect()
		setSelectAll()
		updatePlaceholder()
		self.transitionController = ZoomTransitionController(navigationController: navigationController)
		arrowBackView.addTapGestureRecognizer { [weak self] in
			guard let self = self else { return }
			let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
			self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
		}
		
		switch type {
			case .screen:
				titleLabel.text = "Screenshot"
			case .selfie:
				titleLabel.text = "Selfies"
			case .gif:
				titleLabel.text = "Gif"
			case .live:
				titleLabel.text = "Live photos"
		}
    }
	
	func setupArraysOfAsset() {
		if assetsForDeletion.isEmpty {
			self.deletionButton.isHidden = true
		}
	}
	
	func setupImageManager() {
		
	}
	
	func setupCollectionView() {
		collectionView.register(cellType: AssetCollectionViewCell.self)
		collectionView.allowsSelection = false
		collectionView.allowsMultipleSelection = false
	}
	
	func updatePlaceholder() {
		if assets.isEmpty {
			switch type {
				case .screen:
					titleLabel.text = "No screenshots found..."
				case .selfie:
					titleLabel.text = "Selfie not found..."
				case .gif:
					titleLabel.text = "Gifs not found..."
				case .live:
					titleLabel.text = "No live photos found..."
			}
			self.placeholderLabel.isHidden = false
			self.deletionButton.isHidden = false
			self.deletionButton.setTitle("On the photo cleanup", for: .normal)
			self.selectLabel.isHidden = true
			self.selectAllView.isHidden = true
		}
	}
	
	func setSelectAll() {
		selectAllLabel.addTapGestureRecognizer { [weak self] in
			guard let self = self else { return }
			self.selectMode = true
			self.assetsForDeletion = Set(self.assets)
			self.deletionButton.isHidden = false
			self.deletionButton.setTitle("Delete \(self.assetsForDeletion.count) photos", for: .normal)
			self.collectionView.reloadData()
		}
	}
	
	func setSelect() {
		selectLabel.addTapGestureRecognizer { [weak self] in
			guard let self = self else { return }
			self.selectMode.toggle()
			self.collectionView.reloadData()
		}
	}
	
	@IBAction func deletePhotos(_ sender: Any) {
		if delete(assets: Array(assetsForDeletion)) {
			self.deletionButton.isHidden = true
			self.assetsInput = self.assetsInput.filter({ !assetsForDeletion.contains($0) })
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

extension RegularAssetsViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return assets.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: AssetCollectionViewCell = self.collectionView.dequeueReusableCell(for: indexPath)
		if self.assetsForDeletion.contains(self.assets[indexPath.item]) {
			cell.isChecked = true
		} else {
			cell.isChecked = false
		}
		let photosURL = assets[indexPath.row].sd_URLRepresentation
		cell.setupSelectMode(isON: selectMode)
		cell.addTapGestureRecognizer(action: { [weak self] in
			guard let self = self else { return }
			self.currentIndexPath = indexPath
			if !self.selectMode {
				switch self.type {
					case .screen, .gif, .selfie:
						let gallery = DKPhotoGallery()
						var dkarr = [DKPhotoGalleryItem]()
						self.assets.forEach { asset in
							dkarr.append(DKPhotoGalleryItem(asset: asset))
						}
						gallery.presentationIndex = indexPath.item
						gallery.items = dkarr
						gallery.singleTapMode = .dismiss
						gallery.presentingFromImageView = cell.photoImageView
						gallery.finishedBlock = { [weak self] dismissIndex, dismissItem in
							if dkarr[indexPath.item] == dismissItem {
								return cell.photoImageView
							} else {
								self?.collectionView.scrollToItem(at: IndexPath(item: dismissIndex, section: 0), at: .centeredVertically, animated: false)
								return nil
							}
						}
						self.present(photoGallery: gallery)
						//self.showPlainAsset(asset: self.assets[indexPath.row], index: indexPath.item)
					case .live:
                    break
						//self.showLive(asset: self.assets[indexPath.row])
				}

			} else {
				cell.isChecked.toggle()
				if !self.assetsForDeletion.contains(self.assets[indexPath.row]) {
					self.assetsForDeletion.insert(self.assets[indexPath.row])
				} else {
					self.assetsForDeletion.remove(self.assets[indexPath.row])
				}

				if self.assetsForDeletion.isEmpty {
					self.deletionButton.isHidden = true
				} else {
					self.deletionButton.isHidden = false
					self.deletionButton.setTitle("Delete \(self.assetsForDeletion.count) photos", for: .normal)
				}
			}
		})
		return cell
	}
	
	func showPlainAsset(asset: PHAsset, index: Int) {
		let gallery = DKPhotoGallery()
		gallery.singleTapMode = .dismiss
		//gallery.presentingFromImageView = 
		gallery.items = [DKPhotoGalleryItem(asset: self.assets[index])]
		self.present(photoGallery: gallery)
	}
}
