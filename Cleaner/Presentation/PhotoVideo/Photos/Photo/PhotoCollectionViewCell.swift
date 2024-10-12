//
//  PhotoCollectionViewCell.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 23.05.2022.
//

import Reusable
import Photos
import UIKit
import Haneke
import Disk

class PhotoCollectionViewCell: UICollectionViewCell, NibReusable {

	@IBOutlet var photoImageView: UIImageView!
	@IBOutlet var selectImageView: UIImageView!
	var asset = UIImage()
	
	var isChecked: Bool = false {
		didSet {
			if isChecked {
				selectImageView.image = Asset.mainCPU.image
			} else {
//				selectImageView.image = Asset.mainRAM.image
			}
			selectImageView.isHidden = !isChecked
		}
	}

	
	override func awakeFromNib() {
		super.awakeFromNib()
		selectImageView.isHidden = !isChecked
		layer.cornerRadius = 10.0
		layer.masksToBounds = true
	}
	
	func setupSelectMode(isON: Bool) {
		if isON {
			selectImageView.isHidden = false
		} else {
			selectImageView.isHidden = true
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		photoImageView.image = nil
		selectImageView.image = nil
	}
	
	func setupForStorage(with image: String) {
		do {
			let retrievedImage = try Disk.retrieve(image, from: .documents, as: UIImage.self)
			photoImageView.image = retrievedImage
		} catch {
			print()
		}
	}

}
