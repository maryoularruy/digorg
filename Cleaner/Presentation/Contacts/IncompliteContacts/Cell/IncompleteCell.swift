//
//  IncompleteCell.swift
//  Cleaner
//
//  Created by Максим Лебедев on 20.10.2023.
//

import UIKit
import Reusable

class IncompleteCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                statusImage.image = Asset.selectedCheckBox.image
            } else {
                statusImage.image = Asset.emptyCheckBox.image
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        infoLabel.text = nil
        statusImage.image = nil
    }
}
