//
//  UserDefaultsService.swift
//  Cleaner
//
//  Created by Elena Sedunova on 30.10.2024.
//

import Foundation

enum UserDefaultsKey: String {
    case secretAlbumPassword = "SECRET_ALBUM_PASSWORD"
}

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    func get<T>(_ value: T.Type, key: UserDefaultsKey) -> T? {
        UserDefaults.standard.value(forKey: key.rawValue) as? T
    }
    
    func set<T>(_ value: T, key: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func remove<T>(_ value: T, key: UserDefaultsKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
