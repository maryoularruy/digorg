//
//  TextFieldWithPadding.swift
//  Cleaner
//
//  Created by Elena Sedunova on 21.01.2025.
//

import UIKit

final class TextFieldWithPadding: UITextField {
    private lazy var textPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
