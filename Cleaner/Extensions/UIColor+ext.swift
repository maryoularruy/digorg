//
//  UIColor+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.03.2025.
//

import UIKit.UIColor

extension UIColor {
    convenience init?(hex: String) {
        guard hex.conforms(to: "[a-fA-F0-9]+") else { return nil }
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        guard scanner.scanHexInt64(&hexNumber) else { return nil }
        self.init(hex: hexNumber)
    }
    
    convenience init(hex: UInt64) {
        let r = CGFloat((hex >> 16) & 0xff) / 255
        let g = CGFloat((hex >> 08) & 0xff) / 255
        let b = CGFloat((hex >> 00) & 0xff) / 255
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
