//
//  UnresolvedItemCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.10.2024.
//

import UIKit

protocol UnresolvedItemCellProtocol: AnyObject {
    func tapOnCheckBox()
    func tapOnCell()
}

class UnresolvedItemCell: UITableViewCell {
    @IBOutlet var view: UIView!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var name: Semibold15LabelStyle!
    @IBOutlet weak var number: Regular15LabelStyle!
    
    weak var delegate: UnresolvedItemCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnCell()
        }
    }
    
    @IBAction func tapOnCheckBox(_ sender: Any) {
        delegate?.tapOnCheckBox()
    }
}
