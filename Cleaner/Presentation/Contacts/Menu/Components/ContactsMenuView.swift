//
//  ContactsMenuView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 17.10.2024.
//

import UIKit

final class ContactsMenuView: UIView {
    private lazy var nibName = "ContactsMenuView"
    
    enum ContactsInfoType: String {
        case duplicateNames = "Duplicate Names"
        case dublicateNumbers = "Duplicate Numbers"
        case noNameContacts = "No name"
        case noNumberContacts = "No number"
        
        var icon: UIImage {
            switch self {
            case .duplicateNames: UIImage.duplicateContactNamesIcon
            case .dublicateNumbers: UIImage.duplicateContactNumbersIcon
            case .noNameContacts: UIImage.noNameContactsIcon
            case .noNumberContacts: UIImage.noNumberContactsIcon
            }
        }
    }
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: Semibold15LabelStyle!
    @IBOutlet weak var unresolvedItemsCount: Regular15LabelStyle!
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func bind(type: ContactsInfoType) {
        iconImageView.image = type.icon
        titleLabel.text = type.rawValue
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(nibName, owner: self)
        layer.cornerRadius = 20
        backgroundColor = .red
        addShadows()
        addSubview(contentView)
        contentView.frame = bounds
    }
}
