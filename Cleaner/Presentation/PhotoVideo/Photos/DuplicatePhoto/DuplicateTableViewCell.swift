//
//  DuplicateTableViewCell.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 27.05.2022.
//

import Haneke
import SDWebImagePhotosPlugin
import Photos
import Reusable
import UIKit

class DuplicateTableViewCell: UITableViewCell, NibReusable {
//	@IBOutlet var collectionView: UICollectionView!
	var assets = [PHAsset]()
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
//	@IBOutlet var selectAllView: UIView!
	var onTapSelectAll: (([PHAsset]) -> ())?
	@IBOutlet var duplicatesAmountLabel: UILabel!
	var assetsForDeletion = Set<PHAsset>()
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //		self.collectionView.dataSource = self
        //		self.collectionView.delegate = self
        //		self.collectionView.register(cellType: PhotoCollectionViewCell.self)
        //		self.collectionView.reloadData()
        //		selectAllView.addTapGestureRecognizer {
        //			self.onTapSelectAll?(self.assets)
        //		}
    }
	
	func setupSelectMode(isON: Bool) {
		selectMode = isON
	}
	
	override func prepareForReuse() {
//		self.collectionView.reloadData()
	}
	
	func setupData(assets: [PHAsset]) {
		self.assets = assets
		duplicatesAmountLabel.text = "Duplicates: \(assets.count)"
	}
}

//extension DuplicateTableViewCell: UICollectionViewDataSource {
//	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//		return assets.count
//	}
//    
//    func getAssetThumbnail(asset: PHAsset) -> UIImage {
//        let manager = PHImageManager.default()
//        let option = PHImageRequestOptions()
//        var thumbnail = UIImage()
//        option.isSynchronous = true
//        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
//            thumbnail = result!
//        })
//        return thumbnail
//    }
//    
//	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//		let cell: PhotoCollectionViewCell = self.collectionView.dequeueReusableCell(for: indexPath)
//		let photosURL = assets[indexPath.row].sd_URLRepresentation
//        cell.photoImageView.image = getAssetThumbnail(asset: assets[indexPath.item])
//		//cell.photoImageView.sd_setImage(with: photosURL as URL?, placeholderImage: nil, options: [], context: [SDWebImageContextOption.storeCacheType: SDImageCacheType.all.rawValue])
//		if self.assetsForDeletion.contains(self.assets[indexPath.item]) {
//			cell.isChecked = true
//		} else {
//			cell.isChecked = false
//		}
//		cell.setupSelectMode(isON: selectMode)
//		cell.addTapGestureRecognizer {
//			if self.selectMode {
//				cell.isChecked.toggle()
//				self.onTapWithSelectMode?(indexPath.item)
//			} else {
//				self.onTap?(self.assets, indexPath.item)
//			}
//		}
//		return cell
//	}
//	
//	
//}
//
//extension DuplicateTableViewCell: UICollectionViewDelegate {
//	
//}
