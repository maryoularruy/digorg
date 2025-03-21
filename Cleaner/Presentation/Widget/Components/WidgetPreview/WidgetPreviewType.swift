//
//  WidgetPreviewType.swift
//  Cleaner
//
//  Created by Elena Sedunova on 21.03.2025.
//

import UIKit

enum WidgetPreviewType: CaseIterable {
    case battery, storage
    
    var index: Int {
        switch self {
        case .battery: 0
        case .storage: 1
        }
    }
    
    var title: String {
        switch self {
        case .battery: "Battery"
        case .storage: "Storage"
        }
    }
    
    var defaultValue: String {
        switch self {
        case .battery: "25 %"
        case .storage: "87 %"
        }
    }
    
    var info: String {
        switch self {
        case .battery: "No activity"
        case .storage: "Storage Usage"
        }
    }
    
    var infoValue: String {
        switch self {
        case .battery: "Low power mode\ndisabled"
        case .storage: "112GB / 128 GB"
        }
    }
    
    var smallImage: UIImage {
        switch self {
        case .battery: UIImage(resource: .batteryWidgetSmallIcon)
            //TODO: -add storage widget icon
        case .storage: UIImage(resource: .batteryWidgetSmallIcon)
        }
    }
    
    var mediumImage: UIImage {
        switch self {
        case .battery: UIImage(resource: .batteryWidgetMediumIcon)
            //TODO: -add storage widget icon
        case .storage: UIImage(resource: .batteryWidgetMediumIcon)
        }
    }
}
