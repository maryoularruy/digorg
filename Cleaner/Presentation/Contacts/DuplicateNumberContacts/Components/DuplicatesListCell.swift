//
//  DuplicatesListCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 26.12.2024.
//

import UIKit
import Contacts

protocol DuplicatesListCellDelegate: AnyObject {
    func tapOnCell(contact: CNContact)
    func tapOnCheckBox(contact: CNContact)
}

final class DuplicatesListCell: UITableViewCell {
    static var identifier = "DuplicatesListCell"
    static var HEIGHT = 65.0
    
    weak var delegate: DuplicatesListCellDelegate?
    
    private lazy var nameContactLabel: Semibold15LabelStyle = Semibold15LabelStyle()
    private lazy var numbersLabel: Regular15LabelStyle = Regular15LabelStyle()
    private lazy var checkBox: UIImageView = UIImageView(image: .emptyCheckBoxBlue)
    
    private var contact: CNContact?
    private lazy var position: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
        initConstraints()
    }
    
    func bind(_ contact: CNContact, position: Int) {
        self.contact = contact
        self.position = position
        
        
        let fullName = "\(contact.givenName)\(contact.givenName.isEmpty ? "" : " ")\(contact.familyName)"
        if fullName.isEmpty || fullName == "" || fullName == " " {
            let missingText = "Name is missing"
            let attributes = [NSAttributedString.Key.foregroundColor : UIColor.darkGrey]
            let attributedText = NSAttributedString(string: missingText, attributes: attributes)
            nameContactLabel.attributedText = attributedText
        } else {
            nameContactLabel.attributedText = nil
            nameContactLabel.text = fullName
        }
        
        var numbers: [String] = []
        contact.phoneNumbers.forEach { number in
            numbers.append(number.value.stringValue)
        }
        numbersLabel.text = contact.phoneNumbers.isEmpty ? "Number is missing" : numbers.joined(separator: ", ")
        
    }
    
    private func setupCell() {
        backgroundColor = .clear
        clipsToBounds = true
        contentView.clipsToBounds = true
        numbersLabel.setGreyTextColor()
        
        addTapGestureRecognizer { [weak self] in
            guard let self, let contact else { return }
            delegate?.tapOnCell(contact: contact)
        }
        
        checkBox.addTapGestureRecognizer { [weak self] in
            guard let self, let contact else { return }
            delegate?.tapOnCheckBox(contact: contact)
        }
    }
    
    private func initConstraints() {
        contentView.addSubviews([nameContactLabel, numbersLabel, checkBox])
        
        NSLayoutConstraint.activate([
            nameContactLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameContactLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameContactLabel.trailingAnchor.constraint(equalTo: checkBox.leadingAnchor, constant: -10),
            
            numbersLabel.topAnchor.constraint(equalTo: nameContactLabel.bottomAnchor, constant: 5),
            numbersLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            numbersLabel.trailingAnchor.constraint(equalTo: checkBox.leadingAnchor, constant: -10),
            numbersLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            checkBox.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 23.5),
            checkBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkBox.heightAnchor.constraint(equalToConstant: 26),
            checkBox.widthAnchor.constraint(equalToConstant: 26)
        ])
    }
}
