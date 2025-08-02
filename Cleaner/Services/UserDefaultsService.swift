//
//  UserDefaultsService.swift
//  Cleaner
//
//  Created by Elena Sedunova on 30.10.2024.
//

import Foundation

enum UserDefaultsKeys: String {
    
    case isFirstEntry = "IS_FIRST_ENTRY"
    case appOpenCount = "APP_OPEN_COUNT"
    
    case isRemovePhotosAfterImport = "REMOVE_PHOTOS_AFTER_IMPORT"
    case isRemoveContactsAfterImport = "REMOVE_CONTACTS_AFTER_IMPORT"
    
    case secureVaultPasscode = "SECURE_VAULT_PASSWORD"
    case temporaryPasscode = "TEMPORARY_PASSCODE"
    case isPasscodeTurnOn = "PASSCODE_TURN_ON"
    case isPasscodeConfirmed = "PASSCODE_CONFIRMED"
    
    case securityQuestionId = "SECURITY_QUESTION_ID"
    case securityQuestionAnswer = "SECURITY_QUESTION_ANSWER"
    
    case secureVaultFolder = "DEFAULT_SECURE_VAULT_FOLDER"
    case secureContactsFolder = "DEFAULT_SECURE_CONTACTS_FOLDER"
    case secureContactsFile = "DEFAULT_SECURE_CONTACTS_FILE"
    
    case subscriptionExpirationDate = "SUBSCRIPTION_EXPIRATION_DATE"
    
    case batteryWidgetHexBackgroundColor = "BATTERY_WIDGET_BACKGROUND_COLOR"
    case storageWidgetHexBackgroundColor = "STORAGE_WIDGET_BACKGROUND_COLOR"
}

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    static let groupedUserDefaults = UserDefaults(suiteName: "group.com.clean.mastero1")
    
    var isFirstEntry: Bool {
        self.get(Bool.self, key: .isFirstEntry) ?? false
    }
    
    var appOpenCount: Int {
        self.get(Int.self, key: .appOpenCount) ?? 0
    }
    
    var isPasscodeCreated: Bool {
        self.get(String.self, key: .secureVaultPasscode) != nil
    }
    
    var isPasscodeTurnOn: Bool {
        self.get(Bool.self, key: .isPasscodeTurnOn) == true
    }
    
    var isPasscodeConfirmed: Bool {
        self.get(Bool.self, key: .isPasscodeConfirmed) == true
    }
    
    var isRemovePhotosAfterImport: Bool {
        self.get(Bool.self, key: .isRemovePhotosAfterImport) == true
    }
    
    var isRemoveContactsAfterImport: Bool {
        self.get(Bool.self, key: .isRemoveContactsAfterImport) == true
    }
    
    var isSubscriptionActive: Bool {
        guard let expirationDate = self.get(Date.self, key: .subscriptionExpirationDate) else { return false }
        return expirationDate > Date.now
    }
    
    var batteryWidgetHexBackground: String? {
        self.getGroupedUserDefaults(String.self, key: .batteryWidgetHexBackgroundColor)
    }
    
    var storageWidgetHexBackground: String? {
        self.getGroupedUserDefaults(String.self, key: .storageWidgetHexBackgroundColor)
    }
    
    func get<T>(_ value: T.Type, key: UserDefaultsKeys) -> T? {
        UserDefaults.standard.value(forKey: key.rawValue) as? T
    }
    
    func getGroupedUserDefaults<T>(_ value: T.Type, key: UserDefaultsKeys) -> T? {
        UserDefaultsService.groupedUserDefaults?.value(forKey: key.rawValue) as? T
    }
    
    func set<T>(_ value: T, key: UserDefaultsKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func setGroupedUserDefaults<T>(_ value: T, key: UserDefaultsKeys) {
        UserDefaultsService.groupedUserDefaults?.set(value, forKey: key.rawValue)
    }
    
    func incrementAppOpenCount() {
        let currentCount = appOpenCount
        set(currentCount + 1, key: .appOpenCount)
    }
    
    func remove(key: UserDefaultsKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
