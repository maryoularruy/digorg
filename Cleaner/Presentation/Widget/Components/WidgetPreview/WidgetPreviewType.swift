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
    
    var smallInfoValue: String {
        switch self {
        case .battery: "Low power mode\ndisabled"
        case .storage: "112GB / 128 GB"
        }
    }
    
    var mediumInfoValue: String {
        switch self {
        case .battery: "Low power mode disabled"
        case .storage: "112GB / 128 GB"
        }
    }
    
    var smallImage: UIImage {
        switch self {
        case .battery: UIImage(resource: .batteryWidgetSmallIcon)
        case .storage: UIImage(resource: .storageWidgetSmallIcon)
        }
    }
    
    var mediumImageWithWhiteBackground: UIImage {
        switch self {
        case .battery: UIImage(resource: .batteryWidgetMediumWhiteIcon)
        case .storage: UIImage(resource: .storageWidgetMediumWhiteIcon)
        }
    }
    
    var mediumImageWithBlueBackground: UIImage {
        switch self {
        case .battery: UIImage(resource: .batteryWidgetMediumBlueIcon)
        case .storage: UIImage(resource: .batteryWidgetMediumBlueIcon)
        }
    }
}
