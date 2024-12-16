//
//  SelectionButtonStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.10.2024.
//

import UIKit

protocol SelectionButtonDelegate: AnyObject {
    func tapOnButton()
}

enum SelectionButtonText: String {
    case select = "Select"
    case selectAll = "Select All"
    case deselect = "Deselect"
    case deselectAll = "Deselect All"
}

class SelectionButtonStyle: UIButton {
    weak var delegate: SelectionButtonDelegate?
    
    lazy var isClickable: Bool = true {
        didSet {
            isUserInteractionEnabled = isClickable
            layer.opacity = isClickable ? 1.0 : 0.5
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func bind(text: SelectionButtonText) {
        setTitle(text.rawValue, for: .normal)
        setTitle(text.rawValue, for: .selected)
        layoutSubviews()
    }
    
    func setup() {
        backgroundColor = .paleGrey
        layer.cornerRadius = 20
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)

        setTitleColor(.blue, for: .normal)
        setTitleColor(.blue, for: .selected)
        titleLabel?.textAlignment = .center
        titleLabel?.font = .medium12
        
        addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnButton()
        }

        setupShadow()
    }
}
