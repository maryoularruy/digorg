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
    
    static let subscriptionOption: [SettingsOption] = [
        SettingsOption(title: "Subscription", type: .subscriptionInfo)
    ]
    
    static let removeAfterImportOptions: [SettingsOption] = [
        SettingsOption(title: "Photos", isSwitchable: true, type: .photosRemovable),
        SettingsOption(title: "Contacts", isSwitchable: true, type: .contactsRemovable)
    ]
    
    static let passcodeOptions: [SettingsOption] = [
        SettingsOption(title: "Use Passcode", isSwitchable: true, type: .usePasscode),
        SettingsOption(title: "Change Password", type: .changePassword)
    ]
    
    static let applicationOptions: [SettingsOption] = [
        SettingsOption(title: "Share", type: .share),
        SettingsOption(title: "Send Feedback", type: .sendFeedback),
        SettingsOption(title: "Privacy Policy", type: .privacyPolicy),
        SettingsOption(title: "Terms of Use", type: .termsOfUse)
    ]
}
