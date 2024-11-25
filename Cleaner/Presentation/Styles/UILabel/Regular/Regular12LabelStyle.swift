//
//  Regular12LabelStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.11.2024.
//

import UIKit

final class Regular12LabelStyle: Regular11LabelStyle {
    override func setup() {
        font = UIFont.regular12 ?? UIFont.systemFont(ofSize: 12)
        textColor = .darkGrey
    }
}
