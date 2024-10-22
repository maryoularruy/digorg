//
//  CNContact+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 22.10.2024.
//

import SwiftyContacts

extension CNContact {
    func calcRating() -> Int {
        emailAddresses.count +
        phoneNumbers.count +
        (givenName.isEmpty ? 0 : 1) +
        (familyName.isEmpty ? 0 : 1) +
        (middleName.isEmpty ? 0 : 1)
    }
}
