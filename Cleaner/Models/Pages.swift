//
//  Pages.swift
//  Cleaner
//
//  Created by Elena Sedunova on 15.11.2024.
//

import UIKit

enum Pages: CaseIterable {
    enum BatteryOptimizationPage: PageProtocol {
        case pageZero, pageOne, pageTwo, pageThree
        
        var index: Int {
            switch self {
            case .pageZero: 0
            case .pageOne: 1
            case .pageTwo: 2
            case .pageThree: 3
            }
        }
        
        var title: String {
            switch self {
            case .pageZero: "Open Settings"
            case .pageOne: "Go to Battery"
            case .pageTwo: "Tap Battery Health&Charging"
            case .pageThree: "Enable Optimize Battery Charging"
            }
        }
        
        var image: UIImage {
            switch self {
            case .pageZero: .openSettingsInstruction
            case .pageOne: .batteryInstructions2
            case .pageTwo: .batteryInstructions3
            case .pageThree: .batteryInstructions4
            }
        }
    }
    
    enum SafariCachePage: PageProtocol {
        case pageZero, pageOne, pageTwo, pageThree
        
        var index: Int {
            switch self {
            case .pageZero: 0
            case .pageOne: 1
            case .pageTwo: 2
            case .pageThree: 3
            }
        }
        
        var title: String {
            switch self {
            case .pageZero: "Open Settings"
            case .pageOne: "Go to Safari"
            case .pageTwo: "Tap Clear History and Website Data"
            case .pageThree: "Confirm your action"
            }
        }
        
        var image: UIImage {
            switch self {
            case .pageZero: .openSettingsInstruction
            case .pageOne: .safariCache2
            case .pageTwo: .safariCache3
            case .pageThree: .safariCache4
            }
        }
    }
    
    enum TelegramCachePage: PageProtocol {
        case pageZero, pageOne, pageTwo, pageThree, pageFour
        
        var index: Int {
            switch self {
            case .pageZero: 0
            case .pageOne: 1
            case .pageTwo: 2
            case .pageThree: 3
            case .pageFour: 4
            }
        }
        
        var title: String {
            switch self {
            case .pageZero: "Open Telegram"
            case .pageOne: "Go to Settings > Data and Storage"
            case .pageTwo: "Tap Storage Usage"
            case .pageThree: "Choose Clear Entire Cashe"
            case .pageFour: "Select items to remove and Tap Clear"
            }
        }
        
        var image: UIImage {
            switch self {
            case .pageZero: .telegramCache1
            case .pageOne: .telegramCache2
            case .pageTwo: .telegramCache3
            case .pageThree: .telegramCache4
            case .pageFour: .telegramCache5
            }
        }
    }
    
    enum OffloadUnusedApps: PageProtocol {
        case pageZero, pageOne, pageTwo, pageThree
        
        var index: Int {
            switch self {
            case .pageZero: 0
            case .pageOne: 1
            case .pageTwo: 2
            case .pageThree: 3
            }
        }
        
        var title: String {
            switch self {
            case .pageZero: "Open Settings"
            case .pageOne: "Go to Safari"
            case .pageTwo: "Tap Clear History and Website Data"
            case .pageThree: "Confirm your action"
            }
        }
        
        var image: UIImage {
            switch self {
            case .pageZero: .openSettingsInstruction
            case .pageOne: .offloadUnusedApps2
            case .pageTwo: .offloadUnusedApps3
            case .pageThree: .offloadUnusedApps4
            }
        }
    }
    
    enum OptimizeViberMedia: PageProtocol {
        case pageZero, pageOne, pageTwo, pageThree, pageFour, pageFive
        
        var index: Int {
            switch self {
            case .pageZero: 0
            case .pageOne: 1
            case .pageTwo: 2
            case .pageThree: 3
            case .pageFour: 4
            case .pageFive: 5
            }
        }
        
        var title: String {
            switch self {
            case .pageZero: "Open Viber"
            case .pageOne: "Go to More > Settings"
            case .pageTwo: "Choose Media"
            case .pageThree: "Tap Keep Media"
            case .pageFour: "Select Time Period"
            case .pageFive: "Confirm your selection"
            }
        }
        
        var image: UIImage {
            switch self {
            case .pageZero: .optimizeViberMedia1
            case .pageOne: .optimizeViberMedia2
            case .pageTwo: .optimizeViberMedia3
            case .pageThree: .optimizeViberMedia4
            case .pageFour: .optimizeViberMedia5
            case .pageFive: .optimizeViberMedia6
            }
        }
    }
    
    enum WhatsAppCleanup: PageProtocol {
        case pageZero, pageOne, pageTwo, pageThree, pageFour, pageFive
        
        var index: Int {
            switch self {
            case .pageZero: 0
            case .pageOne: 1
            case .pageTwo: 2
            case .pageThree: 3
            case .pageFour: 4
            case .pageFive: 5
            }
        }
        
        var title: String {
            switch self {
            case .pageZero: "Open WhatsApp"
            case .pageOne: "Go to Settings > Storage and Data"
            case .pageTwo: "Tap Manage Storage"
            case .pageThree: "Open Chat"
            case .pageFour: "Select items to remove"
            case .pageFive: "Confirm your action"
            }
        }
        
        var image: UIImage {
            switch self {
            case .pageZero: .whatsAppCleanup1
            case .pageOne: .whatsAppCleanup2
            case .pageTwo: .whatsAppCleanup3
            case .pageThree: .whatsAppCleanup4
            case .pageFour: .whatsAppCleanup5
            case .pageFive: .whatsAppCleanup6
            }
        }
    }
}
