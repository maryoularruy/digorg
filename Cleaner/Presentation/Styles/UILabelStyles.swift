//
//  UILabelStyles.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.10.2024.
//

import UIKit

final class UILabelSubtitleStyle: UILabel {
    let attributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.blackText,
        .font: UIFont.bold15 ?? UIFont.boldSystemFont(ofSize: 15)
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        attributedText = NSAttributedString(string: "", attributes: attributes)
    }
}

final class UILabelSubheadline1Style: UILabel {
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
    
    private func setup() {
        attributedText = NSAttributedString(string: "", attributes: attributes)
    }
}
