//
//  DuplicateTableViewCell.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 27.05.2022.
//

import Photos
import Reusable
import UIKit

protocol DuplicateTableViewCellDelegate: AnyObject {
    func tapOnCell(assets: [PHAsset], currentPosition: Int)
    func tapOnCheckBox(groupIndex: Int, assetIndex: Int)
}

final class DuplicateTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet weak var duplicatesAmountLabel: UILabel!
    @IBOutlet weak var dateLabel: Regular15LabelStyle!
    @IBOutlet weak var selectAllButton: SelectionTransparentButtonStyle!
    @IBOutlet weak var duplicateGroupCV: UICollectionView!
    
    weak var delegate: DuplicateTableViewCellDelegate?
    
    var onTapSelectAll: (([PHAsset]) -> ())?
    
    lazy var index: Int = 0
    
    var assetsForDeletion = Set<PHAsset>()
    
    private lazy var assets = [PHAsset]()
    private lazy var indexOfBest = 0
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateLabel.setGreyTextColor()
        duplicateGroupCV.register(cellType: AssetCollectionViewCell.self)
        duplicateGroupCV.reloadData()
    }
	
	override func prepareForReuse() {
		duplicateGroupCV.reloadData()
	}
	
    func bind(assets: [PHAsset]) {
		self.assets = assets
        selectAllButton.isHidden = true
//        selectAllButton.bind(text: assets.count == assetsForDeletion.count ? .deselectAll : .selectAll)
        selectionStyle = .none
        selectAllButton.addTapGestureRecognizer { [weak self] in
            self?.onTapSelectAll?(assets)
        }
        indexOfBest = PhotoVideoManager.shared.chooseTheBest(assets) ?? 0
		duplicatesAmountLabel.text = "\(assets.count) duplicates"
        guard let firstAssetDate = assets.first?.creationDate else { return }
        dateLabel.bind(text: firstAssetDate.toFullDate())
	}
}

extension DuplicateTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		assets.count
	}
    
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: AssetCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        let item = assets[indexPath.row]
        cell.index = indexPath.row
        cell.photoImageView.image = item.getAssetThumbnail(TargetSize.large.size)
        cell.isChecked = assetsForDeletion.contains(item)
        cell.isBest = indexPath.row == indexOfBest ? true : false
		return cell
	}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tapOnCell(assets: assets, currentPosition: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        TargetSize.large.size
    }
}

extension DuplicateTableViewCell: AssetCollectionViewCellDelegate {
    func tapOnCheckBox(index: Int) {
        delegate?.tapOnCheckBox(groupIndex: self.index, assetIndex: index)
    }
}
