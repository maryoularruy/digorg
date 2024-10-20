//
//  UnresolvedItemCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.10.2024.
//

import UIKit
import Reusable
import Contacts

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
    
    func bind(contact: CNContact) {
        name.text = "\(contact.givenName) \(contact.familyName)"
        
        var numbers: [String] = []
        contact.phoneNumbers.forEach { number in
            numbers.append(number.value.stringValue)
//            numbers.append("+ 2742 (524) 233")
        }
        number.text = numbers.isEmpty ? "Number is missing" : numbers.joined(separator: ", ")
    }
    
    private func setup() {
        number.setGreyTextColor()
        
        content.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnCell()
        }
    }
}
