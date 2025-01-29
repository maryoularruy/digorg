//
//  SettingsOption.swift
//  Cleaner
//
//  Created by Elena Sedunova on 29.01.2025.
//

import Foundation

enum SettingsOptionType {
    case subscriptionInfo, photosRemovable, contactsRemovable, usePasscode, changePassword, share, sendFeedback, privacyPolicy, termsOfUse
}

struct SettingsOption: Equatable {
    let title: String
    var isSwitchable: Bool?
    let type: SettingsOptionType
}
