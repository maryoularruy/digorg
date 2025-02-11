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
    @IBOutlet weak var bestIcon: BestIcon!
    @IBOutlet weak var photoImageView: UIImageView!
	@IBOutlet weak var checkBox: UIImageView!
    
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
    lazy var isBest: Bool = false {
        didSet {
            bestIcon.isHidden = !isBest
        }
    }
	
	override func awakeFromNib() {
		super.awakeFromNib()
        setupUI()
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
