//
//  Regular15LabelStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 17.10.2024.
//

import UIKit

final class Regular15LabelStyle: Regular11LabelStyle {
    override func setup() {
        font = UIFont.regular15 ?? UIFont.systemFont(ofSize: 15)
        textColor = .blackText
    }
    
    func setGreyTextColor() {
        textColor = .greyText
    }
}
