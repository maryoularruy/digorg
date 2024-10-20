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
    func tapOnCheckBox(_ position: (Int, Int))
    func tapOnCell(_ position: (Int, Int))
}

final class UnresolvedItemCell: UITableViewCell, NibReusable {
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var name: Semibold15LabelStyle!
    @IBOutlet weak var number: Regular15LabelStyle!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    weak var delegate: UnresolvedItemCellProtocol?
    
    private lazy var position: (Int, Int) = (0, 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    @IBAction func tapOnCheckBox(_ sender: Any) {
        delegate?.tapOnCheckBox(position)
    }
    
    func bind(contact: CNContact, _ position: (Int, Int)) {
        self.position = position
        name.text = "\(contact.givenName) \(contact.familyName)"
        
        var numbers: [String] = []
        contact.phoneNumbers.forEach { number in
            numbers.append(number.value.stringValue)
        }
        number.text = numbers.isEmpty ? "Number is missing" : numbers.joined(separator: ", ")
    }
    
    func setupFirstCellInSection() {
        content.layer.cornerRadius = 20
        content.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setupLastCellInSection() {
        content.layer.cornerRadius = 20
        content.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    private func setup() {
        number.setGreyTextColor()
        
        content.addTapGestureRecognizer { [weak self] in
            guard let self else { return }
            delegate?.tapOnCell(position)
        }
    }
}
