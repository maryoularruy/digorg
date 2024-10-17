//
//  Regular11LabelStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 17.10.2024.
//

import UIKit

class Regular11LabelStyle: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func bind(text: String) {
        self.text = text
    }
    
    func setup() {
        font = UIFont.regular11 ?? UIFont.systemFont(ofSize: 11)
        textColor = .greyText
    }
}
