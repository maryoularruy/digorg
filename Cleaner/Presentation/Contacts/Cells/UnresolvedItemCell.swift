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
    @IBOutlet weak var firstLabel: Semibold15LabelStyle!
    @IBOutlet weak var secondLabel: Regular15LabelStyle!
    @IBOutlet weak var checkBoxButton: UIImageView!
    
    weak var delegate: UnresolvedItemCellProtocol?
    
    private lazy var position: (Int, Int) = (0, 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func bind(contact: CNContact, _ position: (Int, Int)) {
        self.position = position
        firstLabel.text = "\(contact.givenName) \(contact.familyName)"
        
        var numbers: [String] = []
        contact.phoneNumbers.forEach { number in
            numbers.append(number.value.stringValue)
        }
        secondLabel.text = numbers.isEmpty ? "Number is missing" : numbers.joined(separator: ", ")
    }
    
    func bind(contact: CNContact) {
        firstLabel.text = contact.phoneNumbers.map { $0.value.stringValue }.joined(separator: ", ")
        secondLabel.text = "No name"
    }
    
    func setupFirstCellInSection() {
        content.layer.cornerRadius = 20
        content.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setupLastCellInSection() {
        content.layer.cornerRadius = 20
        content.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func setupCell() {
        clipsToBounds = false
        content.layer.cornerRadius = 20
        content.backgroundColor = .white
        addShadows()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        content.frame = content.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
    }
    
    private func setup() {
        secondLabel.setGreyTextColor()
        
        checkBoxButton.addTapGestureRecognizer { [weak self] in
            guard let self else { return }
            delegate?.tapOnCheckBox(position)
        }
        
        content.addTapGestureRecognizer { [weak self] in
            guard let self else { return }
            delegate?.tapOnCell(position)
        }
    }
}
