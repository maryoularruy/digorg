//
//  InstructionCellType.swift
//  Cleaner
//
//  Created by Elena Sedunova on 15.11.2024.
//

import UIKit

enum InstructionCellType: CaseIterable {
    case safariCache,
         telegramCache,
         offloadUnusedApps,
         optimizeViberMedia,
         whatsAppCleanup
    
    var text: String {
        switch self {
        case .safariCache: "Clean Safari Cache"
        case .telegramCache: "Clean Telegram Cache"
        case .offloadUnusedApps: "Offload Unused Apps"
        case .optimizeViberMedia: "Optimize Viber Media"
        case .whatsAppCleanup: "Clean up WhatsApp"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .safariCache: .safariIcon
        case .telegramCache: .telegramIcon
        case .offloadUnusedApps: .settingsIcon
        case .optimizeViberMedia: .viberIcon
        case .whatsAppCleanup: .whatsAppIcon
        }
    }
}
