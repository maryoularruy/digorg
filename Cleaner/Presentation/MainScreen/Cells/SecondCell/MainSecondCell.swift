//
//  MainSecondCell.swift
//  Cleaner
//
//  Created by Максим Лебедев on 18.10.2023.
//

import UIKit
import Reusable

class MainSecondCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var batteryView: UIView!
    @IBOutlet weak var widgetsView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var passwordsView: UIView!
    @IBOutlet weak var adBlockView: UIView!
    @IBOutlet weak var connectionView: UIView!
    @IBOutlet weak var secretFoldersView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
