//
//  Semibold15LabelStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 17.10.2024.
//

import UIKit

class Semibold15LabelStyle: UILabel {
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
        font = UIFont.semibold15 ?? UIFont.boldSystemFont(ofSize: 15)
        textColor = .black
    }
    
    func setGreyText() {
        textColor = .darkGrey
    }
}
