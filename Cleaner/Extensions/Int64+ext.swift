//
//  Int+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 13.12.2024.
//

import Foundation

extension Int64 {
    var asMegabytes: Int64 {
        self / 1024 / 1024
    }
    
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
            "\(sizeInKB / (1024 * 1024)) GB"
        }
    }
}
