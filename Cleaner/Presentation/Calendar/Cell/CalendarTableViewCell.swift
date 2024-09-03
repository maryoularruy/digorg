//
//  CalendarTableViewCell.swift
//  Cleaner
//
//  Created by Alex on 22.12.2023.
//

import Reusable
import UIKit

class CalendarTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

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
