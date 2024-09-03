//
//  Credentials.swift
//  Cleaner
//
//  Created by Alex on 27.12.2023.
//

import Foundation
import RealmSwift

class Credential: Object {
    @objc dynamic var link: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var isSelected: Bool = false

    convenience init(link: String, username: String, password: String) {
        self.init()
        self.link = link
        self.username = username
        self.password = password
    }
}
