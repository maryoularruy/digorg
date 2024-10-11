//
//  UILabelStyles.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.10.2024.
//

import UIKit

final class UILabelSubtitleStyle: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        font = UIFont.bold15 ?? UIFont.boldSystemFont(ofSize: 15)
        textColor = .blackText
    }
}

class UILabelSubheadline11sizeStyle: UILabel {
    let attributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.greyText,
        .font: UIFont.regular11 ?? UIFont.systemFont(ofSize: 13)
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    fileprivate func setup() {
        font = UIFont.regular11 ?? UIFont.systemFont(ofSize: 11)
        textColor = .greyText
    }
}

final class UILabelSubhealine13sizeStyle: UILabelSubheadline11sizeStyle {
    override func setup() {
        font = UIFont.regular13 ?? UIFont.systemFont(ofSize: 13)
        textColor = .greyText
    }
}
