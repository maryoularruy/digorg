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
    @IBOutlet weak var selectModeButton: UIButtonSecondaryStyle!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var actionToolbar: ActionToolbar!
    
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
	lazy var selectMode = false {
		didSet {
            if selectMode {
                selectModeButton.bind(text: "Deselect")
			} else {
                selectModeButton.bind(text: "Select")
				assetsForDeletion.removeAll()
				deletionButton.isHidden = true
                tableView.reloadData()
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
        setupUI()
		tableView.register(cellType: DuplicateTableViewCell.self)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension GroupedAssetsViewController: ViewControllerProtocol {
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }
        
        selectModeButton.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.selectMode.toggle()
            self.tableView.reloadData()
        }
    }
    
    func setupUI() {
        actionToolbar.toolbarButton.bind(text: "Delete 0 Items, 0 MB")
        actionToolbar.toolbarButton.changeBackgroundColor(.paleBlueButtonBackground)
        
        similarPhotoLabel.text = "Similar Photo"
        duplicatesCountLabel.text = "\(duplicatesCount) files"
        selectMode = false
        updatePlaceholder()
    }
    
    private func updatePlaceholder() {
        if assetGroups.isEmpty {
            self.deletionButton.isHidden = false
            self.selectModeButton.isHidden = true
        }
    }
}
