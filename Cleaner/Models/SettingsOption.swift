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

var removeAfterImportOptions: [SettingsOption] {
    [
        SettingsOption(title: "Photos", isSwitchable: UserDefaultsService.shared.isRemovePhotosAfterImport, type: .photosRemovable),
        SettingsOption(title: "Contacts", isSwitchable: UserDefaultsService.shared.isRemoveContactsAfterImport, type: .contactsRemovable)
    ]
}

var passcodeOptions: [SettingsOption] {
    [
        SettingsOption(title: "Use Passcode", isSwitchable: UserDefaultsService.shared.isPasscodeTurnOn, type: .usePasscode),
        SettingsOption(title: "Change Password", type: .changePassword)
    ]
}

struct SettingsOption: Equatable {
    let title: String
    var isSwitchable: Bool?
    let type: SettingsOptionType
    
    static let subscriptionOption: [SettingsOption] = [
        SettingsOption(title: "Subscription", type: .subscriptionInfo)
    ]
    
    static let applicationOptions: [SettingsOption] = [
        SettingsOption(title: "Share", type: .share),
        SettingsOption(title: "Send Feedback", type: .sendFeedback),
        SettingsOption(title: "Privacy Policy", type: .privacyPolicy),
        SettingsOption(title: "Terms of Use", type: .termsOfUse)
    ]
}
