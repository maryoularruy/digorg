//
//  CNContact+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 22.10.2024.
//

import Contacts

extension CNContact {
    var fullName: String {
        "\(givenName)\(givenName.isEmpty ? "" : " ")\(familyName)"
    }
    
    func calcRating() -> Int {
        emailAddresses.count +
        phoneNumbers.count +
        (givenName.isEmpty ? 0 : 1) +
        (familyName.isEmpty ? 0 : 1) +
        (middleName.isEmpty ? 0 : 1)
    }
}
