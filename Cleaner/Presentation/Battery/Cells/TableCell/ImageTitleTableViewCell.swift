//
//  ImageTitleTableViewCell.swift
//  Cleaner
//
//  Created by Alex on 19.12.2023.
//

import Reusable
import UIKit

class ImageTitleTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
