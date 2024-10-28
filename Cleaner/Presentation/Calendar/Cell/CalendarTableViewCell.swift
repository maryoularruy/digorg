//
//  CalendarTableViewCell.swift
//  Cleaner
//
//  Created by Alex on 22.12.2023.
//

import Foundation

struct Event: Equatable {
    var title: String
    var year: Int
    var isSelected: Bool
    var id: String
    var calendar: String
    var formattedDate: String
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        // Compare properties to determine equality
        return lhs.id == rhs.id
    }
}
