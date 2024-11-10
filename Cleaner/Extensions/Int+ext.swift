//
//  Int+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.11.2024.
//

import Foundation

extension Int {
    func toProgressBarValue() -> Float {
        Float(Double(self) / 100)
    }
}
