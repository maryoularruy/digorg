//
//  Date+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 29.10.2024.
//

import Foundation

extension Date {
    func year() -> Int {
        Calendar.current.component(.year, from: self)
    }
}
