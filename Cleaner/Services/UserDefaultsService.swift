//
//  UserDefaultsService.swift
//  Cleaner
//
//  Created by Elena Sedunova on 30.10.2024.
//

import Foundation

enum UserDefaultsKeys: String {
    
    case isFirstEntry = "IS_FIRST_ENTRY"
    
    case isRemovePhotosAfterImport = "REMOVE_PHOTOS_AFTER_IMPORT"
    case isRemoveContactsAfterImport = "REMOVE_CONTACTS_AFTER_IMPORT"
    
    case secretAlbumPasscode = "SECRET_ALBUM_PASSWORD"
    case temporaryPasscode = "TEMPORARY_PASSCODE"
    case isPasscodeTurnOn = "PASSCODE_TURN_ON"
    case isPasscodeConfirmed = "PASSCODE_CONFIRMED"
    
    case securityQuestionId = "SECURITY_QUESTION_ID"
    case securityQuestionAnswer = "SECURITY_QUESTION_ANSWER"
    
    case secretAlbumFolder = "DEFAULT_SECRET_ALBUM_FOLDER"
    case secretContactsFolder = "DEFAULT_SECRET_CONTACTS_FOLDER"
    case secretContactsFile = "DEFAULT_SECRET_CONTACTS_FILE"
    
    case subscriptionExpirationDate = "SUBSCRIPTION_EXPIRATION_DATE"
    
    case batteryWidgetHexBackgroundColor = "BATTERY_WIDGET_BACKGROUND_COLOR"
    case storageWidgetHexBackgroundColor = "STORAGE_WIDGET_BACKGROUND_COLOR"
}

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    var isFirstEntry: Bool {
        self.get(Bool.self, key: .isFirstEntry) ?? true
    }
    
    var isPasscodeCreated: Bool {
        self.get(String.self, key: .secretAlbumPasscode) != nil
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
        self.get(String.self, key: .batteryWidgetHexBackgroundColor)
    }
    
    var storageWidgetHexBackground: String? {
        self.get(String.self, key: .storageWidgetHexBackgroundColor)
    }
    
    func get<T>(_ value: T.Type, key: UserDefaultsKeys) -> T? {
        UserDefaults.standard.value(forKey: key.rawValue) as? T
    }
    
    func set<T>(_ value: T, key: UserDefaultsKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func remove(key: UserDefaultsKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
