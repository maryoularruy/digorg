//
//  TutorialCell.swift
//  Cleaner
//
//  Created by Максим Лебедев on 08.10.2023.
//

import UIKit
import Reusable

class TutorialCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(data: OnboardingModel) {
        textLabel.attributedText = data.text
        image.image = data.image
    }
    
}
