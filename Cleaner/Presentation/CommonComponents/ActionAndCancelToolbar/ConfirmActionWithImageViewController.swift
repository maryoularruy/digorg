//
//  ConfirmActionWithImageViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 30.10.2024.
//

import UIKit
import BottomPopup

enum ConfirmActionWithImageType {
    case createPasscode
    
    var title: String {
        switch self {
        case .createPasscode: "This is your secret repository!"
        }
    }
    
    var subtitle: String {
        switch self {
        case .createPasscode: "Create a Passcode to protect your private photos and videos"
        }
    }
    
    var dismissButtonText: String {
        switch self {
        case .createPasscode: "See Later"
        }
    }
    
    var image: UIImage {
        switch self {
        case .createPasscode: .stars
        }
    }
}

final class ConfirmActionWithImageViewController: BottomPopupViewController {
    static var idenfifier = "ConfirmActionWithImageViewController"
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    lazy var actionButtonText: String = ""
    lazy var type: ConfirmActionWithImageType? = nil
    
    
    
    override var popupHeight: CGFloat { height ?? 300.0 }
    override var popupTopCornerRadius: CGFloat { topCornerRadius ?? 20.0 }
    override var popupPresentDuration: Double { presentDuration ?? 0.2 }
    override var popupDismissDuration: Double { dismissDuration ?? 0.2 }
    override var popupShouldDismissInteractivelty: Bool { shouldDismissInteractivelty ?? true }
}
