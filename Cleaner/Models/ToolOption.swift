//
//  ToolOption.swift
//  Cleaner
//
//  Created by Elena Sedunova on 30.10.2024.
//

import UIKit

enum ToolOption: String {
    case secretAlbum = "Secret Album",
         secretContact = "Secret Contact",
         networkSpeedTest = "Network Speed Test",
         widgets = "Widgets",
         battery = "Battery"
    
    var icon: UIImage {
        switch self {
        case .secretAlbum: .secretAlbum
        case .secretContact: .secretContact
        case .networkSpeedTest: .networkSpeedTest
        case .widgets: .widgets
        case .battery: .battery
        }
    }
    
    var description: String {
        switch self {
        case .secretAlbum: "Secret folder for photos and videos"
        case .secretContact: "Secret contact folder"
        case .networkSpeedTest: "Check your internet connection’s performance"
        case .widgets: "Personalize your Home screen"
        case .battery: "Save your battery life"
        }
    }
    
    var isProFunction: Bool {
        switch self {
        case .secretAlbum: true
        case .secretContact: true
        case .networkSpeedTest: false
        case .widgets: false
        case .battery: false
        }
    }
}
