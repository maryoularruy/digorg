//
//  ContactsInfoType.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.10.2024.
//

import UIKit

enum ContactsInfoType: String {
    case duplicateNames = "Duplicate Names"
    case dublicateNumbers = "Duplicate Numbers"
    case noNameContacts = "No name"
    case noNumberContacts = "No number"
    
    var icon: UIImage {
        switch self {
        case .duplicateNames: UIImage.duplicateContactNamesIcon
        case .dublicateNumbers: UIImage.duplicateContactNumbersIcon
        case .noNameContacts: UIImage.noNameContactsIcon
        case .noNumberContacts: UIImage.noNumberContactsIcon
        }
    }
}
