//
//  UnresolvedItemCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.10.2024.
//

import UIKit
import Reusable

protocol UnresolvedItemCellProtocol: AnyObject {
    func tapOnCheckBox()
    func tapOnCell()
}

final class UnresolvedItemCell: UITableViewCell, NibReusable {
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var name: Semibold15LabelStyle!
    @IBOutlet weak var number: Regular15LabelStyle!
    
    weak var delegate: UnresolvedItemCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    @IBAction func tapOnCheckBox(_ sender: Any) {
        delegate?.tapOnCheckBox()
    }
    
    func bind() {
        name.text = "Laial"
        number.text = "+23802403903"
    }
    
    private func setup() {
        number.setGreyTextColor()
        
        content.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnCell()
        }
    }
}
