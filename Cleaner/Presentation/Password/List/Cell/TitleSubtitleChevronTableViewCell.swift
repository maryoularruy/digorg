//
//  TitleSubtitleChevronTableViewCell.swift
//  Cleaner
//
//  Created by Alex on 27.12.2023.
//

import Reusable
import UIKit

class TitleSubtitleChevronTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkLeadingConstraint: NSLayoutConstraint!
    var isCellSelected = false
    
    override func prepareForReuse() {
        isCellSelected = false
        checkMarkImageView.image = Asset.emptyCheckBox.image
    }
}
