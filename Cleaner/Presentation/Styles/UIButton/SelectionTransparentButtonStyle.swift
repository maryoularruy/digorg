//
//  SelectionTransparentButtonStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.10.2024.
//

import UIKit

final class SelectionTransparentButtonStyle: SelectionButtonStyle {
    override func setup() {
        backgroundColor = .clear
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)

        setTitleColor(.blue, for: .normal)
        setTitleColor(.blue, for: .selected)
        titleLabel?.textAlignment = .center
        titleLabel?.font = .medium12
    }
}
