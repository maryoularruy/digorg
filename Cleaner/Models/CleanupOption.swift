//
//  CleanupOption.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.10.2024.
//
import UIKit

enum CleanupOption: String, CaseIterable {
    case photos = "Photos Organization",
         videos = "Videos Organization",
         contacts = "Contacts Organization",
         calendar = "Calendar Organization"
    
    var image: ImageResource {
        switch self {
        case .photos: .photosCleanupIcon
        case .videos: .videosCleanupIcon
        case .contacts: .contactsCleanupIcon
        case .calendar: .calendarCleanupIcon
        }
    }
    
    var mode: Mode? {
        switch self {
        case .photos: .duplicatePhotos
        case .videos: .duplicateVideos
        case .contacts: nil
        case .calendar: nil
        }
    }
    
    var gradientColor: UIColor {
        switch self {
        case .photos: .orange
        case .videos: .acidGreen
        case .contacts: .blue
        case .calendar: .purple
        }
    }
    
    func getPossibleModes() -> [Mode] {
        switch self {
        case .photos: [.duplicatePhotos]
        case .videos: [.duplicateVideos]
        case .contacts: [.duplicateContacts, .imcompleteContacts]
        case .calendar: []
        }
    }
}
