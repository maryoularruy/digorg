//
//  CalendarHeader.swift
//  Cleaner
//
//  Created by Alex on 22.12.2023.
//

import UIKit

class CalendarHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var checkboxImageView: UIImageView!
    var onSelect: (() -> ())?
    var isSelected = false
    var section = 0
    var events = [Event]()
    
    func select() {
        if events.allSatisfy( { $0.isSelected == false }) {
            checkboxImageView.image = Asset.emptyCheckBox.image
        }
        if events.allSatisfy( { $0.isSelected == true }) {
            checkboxImageView.image = Asset.selectedCheckBox.image
        }
    }
    
    func setup() {
        if events.allSatisfy( { $0.isSelected == false }) {
            checkboxImageView.image = Asset.emptyCheckBox.image
        }
        if events.allSatisfy( { $0.isSelected == true }) {
            checkboxImageView.image = Asset.selectedCheckBox.image
        }
    }
}
