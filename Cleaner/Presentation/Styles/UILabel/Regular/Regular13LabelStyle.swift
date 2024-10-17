//
//  Regular13LabelStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 17.10.2024.
//

import UIKit

final class UILabelSubhealine13sizeStyle: Regular11LabelStyle {
    override func setup() {
        font = UIFont.regular13 ?? UIFont.systemFont(ofSize: 13)
        textColor = .greyText
    }
}
