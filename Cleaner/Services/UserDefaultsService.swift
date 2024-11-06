//
//  UserDefaultsService.swift
//  Cleaner
//
//  Created by Elena Sedunova on 30.10.2024.
//

import Foundation

enum UserDefaultsKey: String {
    case secretAlbumPasscode = "SECRET_ALBUM_PASSWORD"
    case secretPasscodeConfirmed = "PASSCODE_CONFIRMED"
    case secretAlbumFolder = "DEFAULT_SECRET_ALBUM_FOLDER"
}

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    var isPasscodeCreated: Bool {
        self.get(String.self, key: .secretAlbumPasscode) != nil
    }
    
    var isPasscodeConfirmed: Bool {
        self.get(Bool.self, key: .secretPasscodeConfirmed) == true
    }
    
    func get<T>(_ value: T.Type, key: UserDefaultsKey) -> T? {
        UserDefaults.standard.value(forKey: key.rawValue) as? T
    }
    
    func set<T>(_ value: T, key: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func remove(key: UserDefaultsKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
