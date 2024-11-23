//
//  DismissButtonStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 21.10.2024.
//

import UIKit

final class DismissButtonStyle: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func bind(text: String) {
        titleLabel?.text = text
    }
    
    private func setup() {
        layer.cornerRadius = 34
        titleLabel?.textAlignment = .center
        backgroundColor = .white
        titleLabel?.textColor = .blue
        titleLabel?.font = .semibold15
    }
}
