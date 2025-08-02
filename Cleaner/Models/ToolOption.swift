//
//  ToolOption.swift
//  Cleaner
//
//  Created by Elena Sedunova on 30.10.2024.
//

import UIKit

enum ToolOption: String, CaseIterable {
    case secureVault = "Secure Vault",
         secureContacts = "Secure Contacts",
         networkSpeedTest = "Network Speed Test",
         widgets = "Widgets",
         battery = "Battery"
    
    var icon: UIImage {
        switch self {
        case .secureVault: .secureVault
        case .secureContacts: .secureContacts
        case .networkSpeedTest: .networkSpeedTest
        case .widgets: .widgets
        case .battery: .battery
        }
    }
    
    var description: String {
        switch self {
        case .secureVault: "Organize and protect your media files"
        case .secureContacts: "Organize and protect your contacts"
        case .networkSpeedTest: "Check your internet connection's performance"
        case .widgets: "Personalize your Home screen"
        case .battery: "Save your battery life"
        }
    }
}
