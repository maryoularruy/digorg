//
//  Medium12ButtonStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.10.2024.
//

import UIKit

final class Medium12ButtonStyle: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func bind(text: String) {
        setTitle(text, for: .normal)
        setTitle(text, for: .selected)
    }
    
    private func setup() {
        backgroundColor = .blue
        layer.cornerRadius = 20
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 0)
        
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = .paleGrey
        titleLabel?.font = .medium12
        
        imageView?.contentMode = .scaleAspectFill
        setImage(.arrowForwardWhite, for: .normal)
        tintColor = .paleGrey
        imageEdgeInsets = if titleLabel == nil || titleLabel?.text == "" || titleLabel?.text == " " {
            UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        } else {
            UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 12)
        }
        semanticContentAttribute = .forceRightToLeft
    }
}
