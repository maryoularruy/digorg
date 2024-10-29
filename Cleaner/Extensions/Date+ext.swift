//
//  Date+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 29.10.2024.
//

import Foundation

fileprivate let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter
}()

extension Date {
    func year() -> Int {
        Calendar.current.component(.year, from: self)
    }
    
    func toYear() -> String {
        formatter.string(from: self)
    }
}
