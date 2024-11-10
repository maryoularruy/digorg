//
//  BatteryInstructionCellType.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.11.2024.
//

import UIKit

enum BatteryInstructionCellType: CaseIterable {
    case optimizeBatteryCharging,
         lowPowerMode,
         managingConnections,
         locationServices,
         batteryUsage,
         backgroundRefresh,
         brightness,
         wifiResresh,
         limitNotifications,
         overheating
    
    var text: String {
        switch self {
        case .optimizeBatteryCharging: "Optimize Battery Charging"
        case .lowPowerMode: "Low Power Mode"
        case .managingConnections: "Managing Connections"
        case .locationServices: "Location Services"
        case .batteryUsage: "Battery Usage"
        case .backgroundRefresh: "Background Refresh"
        case .brightness: "Brightness"
        case .wifiResresh: "WI-FI Resresh"
        case .limitNotifications: "Limit Notifications"
        case .overheating: "Overheating"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .optimizeBatteryCharging: .optimizeBatteryCharging
        case .lowPowerMode: .lowPowerMode
        case .managingConnections: .managingConnections
        case .locationServices: .locationServices
        case .batteryUsage: .batteryUsage
        case .backgroundRefresh: .backgroundRefresh
        case .brightness: .brightness
        case .wifiResresh: .wifiRefresh
        case .limitNotifications: .limitNotifications
        case .overheating: .overheating
        }
    }
}
