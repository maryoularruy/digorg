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
    static var HEIGHT = 71.0
    static var LAST_CELL_BOTTOM_CONSTRAINT = 8.0
    
    weak var delegate: DuplicatesListCellDelegate?
    
    private lazy var nameContactLabel: Semibold15LabelStyle = Semibold15LabelStyle()
    private lazy var numbersLabel: Regular15LabelStyle = Regular15LabelStyle()
    private lazy var labelsContainer: UIView = UIView()
    private lazy var checkBox: UIImageView = UIImageView(image: .emptyCheckBoxBlue)
    
    private var contact: CNContact?
    private lazy var position: Int = 0
    
    private lazy var labelsContainerBottomConstraint = labelsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    
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
    
    func bind(_ contact: CNContact, position: Int, duplicateNumber: String, isSelected: Bool, isLast: Bool) {
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
        
        var numbers: [String] = [duplicateNumber]
        contact.phoneNumbers.forEach { number in
            if duplicateNumber != number.value.stringValue {
                numbers.append(number.value.stringValue)
            }
        }
        numbersLabel.text = contact.phoneNumbers.isEmpty ? "Number is missing" : numbers.joined(separator: ", ")
        
        checkBox.setImage(isSelected ? .selectedCheckBoxBlue : .emptyCheckBoxBlue)
        contentView.backgroundColor = isSelected ? .lightBlue : .paleGrey
        
        labelsContainerBottomConstraint.constant = isLast ? -16 : -8
        layoutIfNeeded()
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
        contentView.addSubviews([labelsContainer, checkBox])
        labelsContainer.addSubviews([nameContactLabel, numbersLabel])
        
        NSLayoutConstraint.activate([
            labelsContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            labelsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelsContainer.trailingAnchor.constraint(equalTo: checkBox.leadingAnchor, constant: -10),
            labelsContainerBottomConstraint,
            
            nameContactLabel.topAnchor.constraint(equalTo: labelsContainer.topAnchor),
            nameContactLabel.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            nameContactLabel.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor),
            
            numbersLabel.topAnchor.constraint(equalTo: nameContactLabel.bottomAnchor, constant: 5),
            numbersLabel.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            numbersLabel.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor),
            numbersLabel.bottomAnchor.constraint(equalTo: labelsContainer.bottomAnchor),
            
            checkBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkBox.centerYAnchor.constraint(equalTo: labelsContainer.centerYAnchor),
            checkBox.heightAnchor.constraint(equalToConstant: 26),
            checkBox.widthAnchor.constraint(equalToConstant: 26)
        ])
    }
}
