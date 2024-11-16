//
//  Pages.swift
//  Cleaner
//
//  Created by Elena Sedunova on 15.11.2024.
//

import UIKit

enum Pages: CaseIterable {
    enum BatteryOptimizationPage: PageProtocol {
        case pageZero
        case pageOne
        case pageTwo
        case pageThree
        
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
            case .pageZero: .batteryInstructions1
            case .pageOne: .batteryInstructions2
            case .pageTwo: .batteryInstructions3
            case .pageThree: .batteryInstructions4
            }
        }
    }
}
