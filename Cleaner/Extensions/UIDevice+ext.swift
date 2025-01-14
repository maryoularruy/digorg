//
//  UIDevice+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 14.01.2025.
//

import UIKit

extension UIDevice {
    static var identifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    static var modelName: String {
        switch UIDevice.identifier {
            case "i386", "x86_64", "arm64": "iPhone Simulator"
            case "iPhone1,1": "iPhone"
            case "iPhone1,2": "iPhone 3G"
            case "iPhone2,1": "iPhone 3GS"
            case "iPhone3,1": "iPhone 4"
            case "iPhone3,2": "iPhone 4 GSM Rev A"
            case "iPhone3,3": "iPhone 4 CDMA"
            case "iPhone4,1": "iPhone 4S"
            case "iPhone5,1": "iPhone 5 (GSM)"
            case "iPhone5,2": "iPhone 5 (GSM+CDMA)"
            case "iPhone5,3": "iPhone 5C (GSM)"
            case "iPhone5,4": "iPhone 5C (Global)"
            case "iPhone6,1": "iPhone 5S (GSM)"
            case "iPhone6,2": "iPhone 5S (Global)"
            case "iPhone7,1": "iPhone 6 Plus"
            case "iPhone7,2": "iPhone 6"
            case "iPhone8,1": "iPhone 6s"
            case "iPhone8,2": "iPhone 6s Plus"
            case "iPhone8,4": "iPhone SE (GSM)"
            case "iPhone9,1": "iPhone 7"
            case "iPhone9,2": "iPhone 7 Plus"
            case "iPhone9,3": "iPhone 7"
            case "iPhone9,4": "iPhone 7 Plus"
            case "iPhone10,1": "iPhone 8"
            case "iPhone10,2": "iPhone 8 Plus"
            case "iPhone10,3": "iPhone X Global"
            case "iPhone10,4": "iPhone 8"
            case "iPhone10,5": "iPhone 8 Plus"
            case "iPhone10,6": "iPhone X GSM"
            case "iPhone11,2": "iPhone XS"
            case "iPhone11,4": "iPhone XS Max"
            case "iPhone11,6": "iPhone XS Max Global"
            case "iPhone11,8": "iPhone XR"
            case "iPhone12,1": "iPhone 11"
            case "iPhone12,3": "iPhone 11 Pro"
            case "iPhone12,5": "iPhone 11 Pro Max"
            case "iPhone12,8": "iPhone SE 2nd Gen"
            case "iPhone13,1": "iPhone 12 Mini"
            case "iPhone13,2": "iPhone 12"
            case "iPhone13,3": "iPhone 12 Pro"
            case "iPhone13,4": "iPhone 12 Pro Max"
            case "iPhone14,2": "iPhone 13 Pro"
            case "iPhone14,3": "iPhone 13 Pro Max"
            case "iPhone14,4": "iPhone 13 Mini"
            case "iPhone14,5": "iPhone 13"
            case "iPhone14,6": "iPhone SE 3rd Gen"
            case "iPhone14,7": "iPhone 14"
            case "iPhone14,8": "iPhone 14 Plus"
            case "iPhone15,2": "iPhone 14 Pro"
            case "iPhone15,3": "iPhone 14 Pro Max"
            case "iPhone15,4": "iPhone 15"
            case "iPhone15,5": "iPhone 15 Plus"
            case "iPhone16,1": "iPhone 15 Pro"
            case "iPhone16,2": "iPhone 15 Pro Max"
            case "iPhone17,1": "iPhone 16 Pro"
            case "iPhone17,2": "iPhone 16 Pro Max"
            case "iPhone17,3": "iPhone 16"
            case "iPhone17,4": "iPhone 16 Plus"
            
            // MARK: - Unrecognized
            default: identifier
        }
    }
    
    static var ramSize: String {
        switch UIDevice.identifier {
            case "i386", "x86_64", "arm64": "iPhone Simulator"
            case "iPhone1,1": "128 MB"
            case "iPhone1,2": "128 MB"
            case "iPhone2,1": "256 MB"
            case "iPhone3,1": "512 MB"
            case "iPhone3,2": "512 MB"
            case "iPhone3,3": "512 MB"
            case "iPhone4,1": "512 MB"
            case "iPhone5,1": "1 GB"
            case "iPhone5,2": "1 GB"
            case "iPhone5,3": "1 GB"
            case "iPhone5,4": "1 GB"
            case "iPhone6,1": "1 GB"
            case "iPhone6,2": "1 GB"
            case "iPhone7,1": "1 GB"
            case "iPhone7,2": "1 GB"
            case "iPhone8,1": "2 GB"
            case "iPhone8,2": "2 GB"
            case "iPhone8,4": "2 GB"
            case "iPhone9,1": "2 GB"
            case "iPhone9,2": "2 GB"
            case "iPhone9,3": "2 GB"
            case "iPhone9,4": "3 GB"
            case "iPhone10,1": "2 GB"
            case "iPhone10,2": "3 GB"
            case "iPhone10,3": "3 GB"
            case "iPhone10,4": "2 GB"
            case "iPhone10,5": "3 GB"
            case "iPhone10,6": "3 GB"
            case "iPhone11,2": "4 GB"
            case "iPhone11,4": "4 GB"
            case "iPhone11,6": "4 GB"
            case "iPhone11,8": "3 GB"
            case "iPhone12,1": "4 GB"
            case "iPhone12,3": "4 GB"
            case "iPhone12,5": "4 GB"
            case "iPhone12,8": "3 GB"
            case "iPhone13,1": "4 GB"
            case "iPhone13,2": "4 GB"
            case "iPhone13,3": "6 GB"
            case "iPhone13,4": "6 GB"
            case "iPhone14,2": "6 GB"
            case "iPhone14,3": "6 GB"
            case "iPhone14,4": "4 GB"
            case "iPhone14,5": "4 GB"
            case "iPhone14,6": "4 GB"
            case "iPhone14,7": "6 GB"
            case "iPhone14,8": "6 GB"
            case "iPhone15,2": "6 GB"
            case "iPhone15,3": "6 GB"
            case "iPhone15,4": "6 GB"
            case "iPhone15,5": "6 GB"
            case "iPhone16,1": "8 GB"
            case "iPhone16,2": "8 GB"
            case "iPhone17,1": "8 GB"
            case "iPhone17,2": "8 GB"
            case "iPhone17,3": "8 GB"
            case "iPhone17,4": "8 GB"
            
            // MARK: - Unrecognized
            default: identifier
        }
    }
}
