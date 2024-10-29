//
//  ToolOption.swift
//  Cleaner
//
//  Created by Elena Sedunova on 30.10.2024.
//

import Foundation

enum ToolOption: String {
    case secretAlbum = "Secret Album",
         secretContacts = "Secret Contacts",
         networkSpeedTest = "Network Speed Test",
         widgets = "Widgets",
         battery = "Battery"
    
//    var icon: UIImage {
//        switch self {
//        case .secretAlbum:
//                
//        case .secretContacts:
//             
//        case .networkSpeedTest:
//             
//        case .widgets:
//             
//        case .battery:
//             
//        }
//    }
    
    var description: String {
        switch self {
        case .secretAlbum: "Secret folder for photos and videos"
        case .secretContacts: "Secret contact folder"
        case .networkSpeedTest: "Check your internet connection’s performance"
        case .widgets: "Personalize your Home screen"
        case .battery: "Save your battery life"
        }
    }
    
    var isProFunction: Bool {
        switch self {
        case .secretAlbum: true
        case .secretContacts: true
        case .networkSpeedTest: false
        case .widgets: false
        case .battery: false
        }
    }
}
