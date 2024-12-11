//
//  DuplicateTableViewCell.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 27.05.2022.
//

import Photos
import Reusable
import UIKit

final class DuplicateTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet var duplicatesAmountLabel: UILabel!
    @IBOutlet weak var duplicateGroupCV: UICollectionView!
    
    var onTap: (([PHAsset], Int) -> ())?
	var onTapWithSelectMode: ((Int) -> ())?
    var onTapSelectAll: (([PHAsset]) -> ())?
    
    lazy var selectMode = false {
        didSet { duplicateGroupCV.reloadData() }
    }
	var assetsForDeletion = Set<PHAsset>()
    private lazy var assets = [PHAsset]()
    private lazy var indexOfBest = 0
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        duplicateGroupCV.register(cellType: AssetCollectionViewCell.self)
        duplicateGroupCV.reloadData()
    }
	
	func setupSelectMode(isON: Bool) {
		selectMode = isON
	}
	
	override func prepareForReuse() {
		duplicateGroupCV.reloadData()
	}
	
	func setupData(assets: [PHAsset]) {
		self.assets = assets
        indexOfBest = PhotoVideoManager.shared.chooseTheBest(assets) ?? 0
		duplicatesAmountLabel.text = "\(assets.count) duplicates"
	}
}

extension DuplicateTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		assets.count
	}
    
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: AssetCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.photoImageView.image = assets[indexPath.item].getAssetThumbnail(TargetSize.large.size)
        cell.isChecked = assetsForDeletion.contains(assets[indexPath.item])
        cell.isBest = indexPath.item == indexOfBest ? true : false
		cell.setupSelectMode(isON: selectMode)
		cell.addTapGestureRecognizer { [weak self] in
            guard let self else { return }
			if self.selectMode {
                cell.checkBox.isHidden = false
				cell.isChecked.toggle()
				self.onTapWithSelectMode?(indexPath.item)
			} else {
                cell.checkBox.isHidden = true
				self.onTap?(self.assets, indexPath.item)
			}
		}
		return cell
	}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        TargetSize.large.size
    }
}
