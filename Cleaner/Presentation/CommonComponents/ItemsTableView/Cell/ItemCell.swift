//
//  ItemCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.10.2024.
//

import UIKit
import Reusable
import Contacts
import EventKit

protocol ItemCellProtocol: AnyObject {
    func tapOnCheckBox(_ position: (Int, Int))
    func tapOnCell(_ position: (Int, Int))
}

final class ItemCell: UITableViewCell, NibReusable {
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var firstLabel: Semibold15LabelStyle!
    @IBOutlet weak var secondLabel: Regular15LabelStyle!
    @IBOutlet weak var checkBoxButton: UIImageView!
    
    enum UnresolvedItemCellType {
        case grouped, single
        
        var insets: UIEdgeInsets {
            switch self {
            case .grouped: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            case .single: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
            }
        }
    }
    
    weak var delegate: ItemCellProtocol?
    
    private lazy var position: (Int, Int) = (0, 0)
    private lazy var type: UnresolvedItemCellType? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    //MARK: -Contact bindings
    func bind(contact: CNContact, _ position: (Int, Int), type: UnresolvedItemCellType = .grouped) {
        self.type = type
        self.position = position
        firstLabel.text = "\(contact.givenName) \(contact.familyName)"
        
        var numbers: [String] = []
        contact.phoneNumbers.forEach { number in
            numbers.append(number.value.stringValue)
        }
        secondLabel.text = numbers.isEmpty ? "Number is missing" : numbers.joined(separator: ", ")
    }
    
    func bind(contact: CNContact, _ position: Int, type: UnresolvedItemCellType = .single) {
        self.type = type
        self.position = (0, position)
        firstLabel.text = "\(contact.givenName) \(contact.familyName)"
        
        var numbers: [String] = []
        contact.phoneNumbers.forEach { number in
            numbers.append(number.value.stringValue)
        }
        secondLabel.text = numbers.isEmpty ? "Number is missing" : numbers.joined(separator: ", ")
    }
    
    func bindNoName(contact: CNContact, _ position: Int, type: UnresolvedItemCellType = .single) {
        self.type = type
        self.position = (0, position)
        firstLabel.text = contact.phoneNumbers.map { $0.value.stringValue }.joined(separator: ", ")
        secondLabel.text = "No name"
    }
    
    func bindNoNumber(contact: CNContact, _ position: Int, type: UnresolvedItemCellType = .single) {
        self.type = type
        self.position = (0, position)
        firstLabel.text = "\(contact.givenName) \(contact.familyName)"
        secondLabel.text = "No phone number"
    }
    
//    MARK: -Calendar bindings
    func bind(event: EKEvent, _ position: (Int, Int), type: UnresolvedItemCellType = .single) {
        self.type = type
        self.position = position
        firstLabel.text = event.title
        secondLabel.text = event.startDate.toYear()
    }
    
//    MARK: -Setup cell's UI
    func setupFirstCellInSection() {
        refreshCornerRadiuses()
        content.layer.cornerRadius = 20
        content.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setupLastCellInSection() {
        refreshCornerRadiuses()
        content.layer.cornerRadius = 20
        content.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func setupMiddleCellInSection() {
        refreshCornerRadiuses()
    }
    
    func setupSingleCellInSection() {
        refreshCornerRadiuses()
        content.layer.cornerRadius = 20
        content.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        content.frame = content.frame.inset(by: type?.insets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    private func setup() {
        clipsToBounds = false
        content.clipsToBounds = true
        secondLabel.setGreyTextColor()
        addShadows()
        
        checkBoxButton.addTapGestureRecognizer { [weak self] in
            guard let self else { return }
            delegate?.tapOnCheckBox(position)
        }
        
        content.addTapGestureRecognizer { [weak self] in
            guard let self else { return }
            delegate?.tapOnCell(position)
        }
    }
    
    private func refreshCornerRadiuses() {
        content.layer.cornerRadius = 0
        content.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
}
