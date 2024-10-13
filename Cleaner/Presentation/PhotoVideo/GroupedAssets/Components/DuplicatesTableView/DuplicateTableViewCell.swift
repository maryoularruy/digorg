//
//  DuplicateTableViewCell.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 27.05.2022.
//

import SDWebImagePhotosPlugin
import Photos
import Reusable
import UIKit

class DuplicateTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet var duplicatesAmountLabel: UILabel!
    @IBOutlet weak var duplicateGroupCV: UICollectionView!
    var onTap: (([PHAsset], Int) -> ())?
	var onTapWithSelectMode: ((Int) -> ())?
	var selectMode = false
//    {
//		didSet {
//			if selectMode {
//                
//			} else {
//                
//			}
//		}
//	}
	var onTapSelectAll: (([PHAsset]) -> ())?
	var assetsForDeletion = Set<PHAsset>()
    private lazy var assets = [PHAsset]()
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.duplicateGroupCV.register(cellType: PhotoCollectionViewCell.self)
        self.duplicateGroupCV.reloadData()
    }
	
	func setupSelectMode(isON: Bool) {
		selectMode = isON
	}
	
	override func prepareForReuse() {
		self.duplicateGroupCV.reloadData()
	}
	
	func setupData(assets: [PHAsset]) {
		self.assets = assets
		duplicatesAmountLabel.text = "\(assets.count) duplicates"
	}
}

extension DuplicateTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return assets.count
	}
    
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: PhotoCollectionViewCell = duplicateGroupCV.dequeueReusableCell(for: indexPath)
//		let photosURL = assets[indexPath.row].sd_URLRepresentation
        cell.photoImageView.image = getAssetThumbnail(asset: assets[indexPath.item])
		//cell.photoImageView.sd_setImage(with: photosURL as URL?, placeholderImage: nil, options: [], context: [SDWebImageContextOption.storeCacheType: SDImageCacheType.all.rawValue])
        cell.isChecked = assetsForDeletion.contains(assets[indexPath.item]) ? true : false
		cell.setupSelectMode(isON: selectMode)
		cell.addTapGestureRecognizer {
			if self.selectMode {
				cell.isChecked.toggle()
				self.onTapWithSelectMode?(indexPath.item)
			} else {
				self.onTap?(self.assets, indexPath.item)
			}
		}
		return cell
	}
    
    private func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 133, height: 133), contentMode: .default, options: option, resultHandler: { (result, info) -> () in
            thumbnail = result!
        })
        return thumbnail
    }
}
