//
//  ImageTitleSubtitleTableViewCell.swift
//  Cleaner
//
//  Created by Alex on 18.12.2023.
//

import Reusable
import UIKit

class ImageTitleSubtitleTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
