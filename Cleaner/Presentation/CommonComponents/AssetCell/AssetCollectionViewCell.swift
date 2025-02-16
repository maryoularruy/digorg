//
//  AssetCollectionViewCell.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 23.05.2022.
//

import Reusable
import UIKit

protocol AssetCollectionViewCellDelegate: AnyObject {
    func tapOnCheckBox(index: Int)
}

final class AssetCollectionViewCell: UICollectionViewCell, NibReusable {
    @IBOutlet weak var bestIcon: BestIcon!
    @IBOutlet weak var photoImageView: UIImageView!
	@IBOutlet weak var checkBox: UIImageView!
    
    weak var delegate: AssetCollectionViewCellDelegate?
    
	lazy var asset = UIImage()
    lazy var index = 0
    
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
    
    func bind(image: UIImage?, isChecked: Bool, index: Int, isBest: Bool? = nil) {
        self.index = index
        if let image {
            photoImageView.setImage(image)
        }
        self.isChecked = isChecked
        
        if let isBest {
            self.isBest = isBest
        }
    }
    
    private func setupUI() {
        layer.cornerRadius = 16.0
                
        checkBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnCheckBox)))
    }
    
    @objc func tapOnCheckBox() {
        delegate?.tapOnCheckBox(index: index)
    }
}
