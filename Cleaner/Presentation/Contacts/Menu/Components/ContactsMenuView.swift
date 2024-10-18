//
//  ContactsMenuView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 17.10.2024.
//

import UIKit

protocol ContactsMenuViewProtocol: AnyObject {
    func tapOnCell(type: ContactsInfoType)
}

final class ContactsMenuView: UIView {
    private lazy var nibName = "ContactsMenuView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: Semibold15LabelStyle!
    @IBOutlet weak var unresolvedItemsCount: Regular15LabelStyle!
    
    private lazy var type: ContactsInfoType? = nil
    weak var delegate: ContactsMenuViewProtocol?
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func bind(type: ContactsInfoType) {
        self.type = type
        iconImageView.image = type.icon
        titleLabel.text = type.rawValue
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(nibName, owner: self)
        layer.cornerRadius = 20
        contentView.layer.cornerRadius = 20
    
        contentView.addTapGestureRecognizer { [weak self] in
            if let type = self?.type {
                self?.delegate?.tapOnCell(type: type)
            }
        }
        
        addShadows()
        addSubview(contentView)
        contentView.frame = bounds
        contentView.clipsToBounds = true
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
