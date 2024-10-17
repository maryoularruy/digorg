//
//  Semibold24LabelStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 17.10.2024.
//

import UIKit

final class Semibold24LabelStyle: Semibold15LabelStyle {
    override func setup() {
        font = UIFont.semibold24 ?? UIFont.boldSystemFont(ofSize: 24)
        textColor = .blackText
    }
}
