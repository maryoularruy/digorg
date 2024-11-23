//
//  SelectionTransparentButtonStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.10.2024.
//

import Foundation

final class SelectionTransparentButtonStyle: SelectionButtonStyle {
    override func setup() {
        layer.cornerRadius = 20
        backgroundColor = .clear
        addShadows()
    }
}
