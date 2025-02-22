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

fileprivate let formatter2: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy"
    return formatter
}()

fileprivate let formatter3: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMMM"
    return formatter
}()

fileprivate let formatter4: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yy"
    return formatter
}()

extension Date {
    func year() -> Int {
        Calendar.current.component(.year, from: self)
    }
    
    func toDayAndMonth() -> String {
        formatter3.string(from: self)
    }
    
    func toYear() -> String {
        formatter.string(from: self)
    }
    
    func toFullDate() -> String {
        formatter2.string(from: self)
    }
    
    func toFullDateWithDots() -> String {
        formatter4.string(from: self)
    }
}
