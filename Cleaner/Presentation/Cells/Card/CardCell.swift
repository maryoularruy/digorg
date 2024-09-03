//
//  CardsCell.swift
//  Cleaner
//
//  Created by Максим Лебедев on 03.10.2023.
//

import Reusable
import UIKit

class CardCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
    }
    
    func setup(data: CardModel) {
        if data.desription == "" {
            descriptionText.isHidden = true
        } else {
            descriptionText.isHidden = false
        }
        title.text = data.title
        descriptionText.text = data.desription
        image.image = data.image
    }
}
