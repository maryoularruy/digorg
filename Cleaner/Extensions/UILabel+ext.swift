//
//  UILabel+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 09.10.2024.
//

import UIKit

extension UILabel {
    static func subheadline() -> UILabel {
        let label = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.greyText,
            .font: UIFont.regular11 ?? UIFont.systemFont(ofSize: 11)
        ]
        label.attributedText = NSAttributedString(string: " ", attributes: attributes)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func subtitle() -> UILabel {
        let label = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.blackText,
            .font: UIFont.bold15 ?? UIFont.boldSystemFont(ofSize: 15)
        ]
        label.attributedText = NSAttributedString(string: " ", attributes: attributes)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
