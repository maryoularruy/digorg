//
//  SelectionButtonStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.10.2024.
//

import UIKit

enum SelectionButtonText: String {
    case select = "Select"
    case selectAll = "Select All"
    case deselect = "Deselect"
    case deselectAll = "Deselect All"
}

class SelectionButtonStyle: UIButton {
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
        titleLabel?.text = text.rawValue
    }
    
    func setup() {
        titleLabel?.textAlignment = .center
        backgroundColor = .paleGrey
        titleLabel?.textColor = .blue
        titleLabel?.font = .medium12
//        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
//        configuration.cornerStyle = .capsule
        addShadow()
    }
}
