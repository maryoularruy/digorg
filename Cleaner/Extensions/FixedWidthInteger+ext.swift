//
//  FixedWidthInteger+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 17.01.2025.
//

import Foundation

extension FixedWidthInteger {
    func toStringWithDot() -> String {
        if self == 0 {
            return "0 MB"
        }
        
        let sizeInKB = Double(self) / 1024
        return if sizeInKB < 1000 {
            String(format: "%.1f", sizeInKB)
                .replacingOccurrences(of: ".0", with: "") + " KB"
        } else if sizeInKB >= 1000 && sizeInKB < 1_000_000 {
            String(format: "%.1f", sizeInKB / 1024)
                .replacingOccurrences(of: ".0", with: "") + " MB"
        } else {
            String(format: "%.1f", sizeInKB / (1024 * 1024))
                .replacingOccurrences(of: ".0", with: "") + " GB"
        }
    }
    
    func toStringWithComma() -> String {
        if self == 0 {
            return "0 MB"
        }
        
        let sizeInKB = Double(self) / 1024
        return if sizeInKB < 1000 {
            String(format: "%.1f", sizeInKB)
                .replacingOccurrences(of: ".0", with: "")
                .replacingOccurrences(of: ".", with: ",") + " KB"
            
        } else if sizeInKB >= 1000 && sizeInKB < 1_000_000 {
            String(format: "%.1f", sizeInKB / 1024)
                .replacingOccurrences(of: ".0", with: "")
                .replacingOccurrences(of: ".", with: ",") + " MB"
        } else {
            String(format: "%.1f", sizeInKB / (1024 * 1024))
                .replacingOccurrences(of: ".0", with: "")
                .replacingOccurrences(of: ".", with: ",") + " GB"
        }
    }
    
    func roundAndToString() -> String {
        if self == 0 {
            return "0 MB"
        }
        
        let sizeInKB = Double(self) / 1024
        return if sizeInKB < 1000 {
            "\(Int(sizeInKB)) KB"
        } else if sizeInKB >= 1000 && sizeInKB < 1_000_000 {
            "\(Int(sizeInKB / 1024)) MB"
        } else {
            "\(Int(sizeInKB / (1024 * 1024))) GB"
        }
    }
}
