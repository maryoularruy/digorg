//
//  Regular13LabelStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 17.10.2024.
//

import UIKit

final class Regular13LabelStyle: Regular11LabelStyle {
    override func setup() {
        font = UIFont.regular13 ?? UIFont.systemFont(ofSize: 13)
        textColor = .darkGrey
    }
    
    func underlined(text: String) {
        let attributes = NSAttributedString(
            string: text,
            attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue,
                         .underlineColor: UIColor.darkGrey]
        )
        self.attributedText = attributes
    }
}
