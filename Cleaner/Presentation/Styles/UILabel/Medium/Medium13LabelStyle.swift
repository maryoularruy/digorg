//
//  Medium13LabelStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.03.2025.
//

import UIKit

final class Medium13LabelStyle: UILabel {
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
        font = UIFont.medium13 ?? UIFont.systemFont(ofSize: 13)
        textColor = .paleGrey
    }
    
    func setPaleGreyTextColor() {
        textColor = .paleGrey
    }
    
    func setBlackTextColor() {
        textColor = .black
    }
}
