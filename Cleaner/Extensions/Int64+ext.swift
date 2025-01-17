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
}
