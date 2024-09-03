//
//  UserDefaults.swift
//  XMASS
//
//  Created by Максим Лебедев on 10.11.2022.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    
    var isFullVersion: DefaultsKey<Bool> { .init("isFullVersion", defaultValue: false) }
    var isOnboardingSeen: DefaultsKey<Bool> { .init("isOnboardingSeen", defaultValue: false) }
    
    var subPeriod: DefaultsKey<String> { .init("subPeriod", defaultValue: "") }
    var subPrice: DefaultsKey<String> { .init("subPrice", defaultValue: "") }
}
