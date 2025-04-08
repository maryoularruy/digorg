//
//  UILabel+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 09.10.2024.
//

import UIKit

extension UILabel {
    static func subheadline() -> UILabel {
        let label = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.darkGrey,
            .font: UIFont.regular11 ?? UIFont.systemFont(ofSize: 11)
        ]
        label.attributedText = NSAttributedString(string: " ", attributes: attributes)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func subtitle() -> UILabel {
        let label = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.bold15 ?? UIFont.boldSystemFont(ofSize: 15)
        ]
        label.attributedText = NSAttributedString(string: " ", attributes: attributes)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    var actualNumberOfLines: Int {
        let textStorage = NSTextStorage(attributedString: attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        layoutManager.addTextContainer(textContainer)

        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var numberOfLines = 0, index = 0, lineRange = NSMakeRange(0, 1)

        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
}
