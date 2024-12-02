//
//  AssetCollectionViewCell.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 23.05.2022.
//

import Reusable
import Photos
import UIKit
import Disk

final class AssetCollectionViewCell: UICollectionViewCell, NibReusable {
	@IBOutlet var photoImageView: UIImageView!
	@IBOutlet var checkBox: UIImageView!
    
	lazy var asset = UIImage()
	lazy var isChecked: Bool = false {
		didSet {
			if isChecked {
                checkBox.image = .selectedCheckBox
			} else {
                checkBox.image = .emptyCheckBoxWhite
			}
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
        setupUI()
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
        layer.cornerRadius = 16.0
    }
}
