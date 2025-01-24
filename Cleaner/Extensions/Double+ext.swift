//
//  Double+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 24.01.2025.
//

import Foundation

extension Double {
    var formatted: String {
        if self == 0 {
            return "0"
        }
        return String(format: "%.1f", self)
    }
}
