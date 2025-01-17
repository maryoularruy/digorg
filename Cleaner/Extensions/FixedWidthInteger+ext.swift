//
//  FixedWidthInteger+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 17.01.2025.
//

import Foundation

extension FixedWidthInteger {
    func convertToString() -> String {
        if self == 0 {
            return "0 MB"
        }
        
        let sizeInKB = self / 1024
        return if sizeInKB < 1000 {
            "\(sizeInKB) KB"
        } else if sizeInKB >= 1000 && sizeInKB < 1_000_000 {
            "\(sizeInKB / 1024) MB"
        } else {
            String(format: "%.1f", (Double(sizeInKB) / (1024 * 1024))) + " GB"
        }
    }
}
