//
//  PhotoCollectionViewCell.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 23.05.2022.
//

import Reusable
import Photos
import UIKit
import Disk

class PhotoCollectionViewCell: UICollectionViewCell, NibReusable {
	@IBOutlet var photoImageView: UIImageView!
	@IBOutlet var checkBox: UIImageView!
    
	lazy var asset = UIImage()
	lazy var isChecked: Bool = false {
		didSet {
			if isChecked {
                checkBox.image = Asset.selectedCheckBox.image
			} else {
                checkBox.image = Asset.emptyCheckBox.image
			}
            checkBox.isHidden = !isChecked
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
        setupUI()
	}
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        checkBox.image = nil
    }
	
	func setupSelectMode(isON: Bool) {
        checkBox.isHidden = isON ? false : true
	}
	
	private func setupForStorage(with image: String) {
		do {
			let retrievedImage = try Disk.retrieve(image, from: .documents, as: UIImage.self)
			photoImageView.image = retrievedImage
		} catch {
			print()
		}
	}
    
    private func setupUI() {
        checkBox.isHidden = !isChecked
        layer.cornerRadius = 16.0
    }
}
