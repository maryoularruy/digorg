//
//  Float+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.11.2024.
//

import Foundation

extension Float {
    func toPercent() -> Int {
        Int(self * 100)
    }
}

extension CGFloat {
    func toPercent() -> Int {
        Int(ceil(self * 100))
    }
}
