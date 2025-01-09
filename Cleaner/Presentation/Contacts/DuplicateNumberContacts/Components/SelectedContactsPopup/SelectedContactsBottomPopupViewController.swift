//
//  SelectedContactsBottomPopupViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 03.01.2025.
//

import UIKit
import BottomPopup

enum SelectedContactsType {
    case mergeContacts, previewContacts
    
    var title: String {
        switch self {
        case .mergeContacts: "Select to merge"
        case .previewContacts: "Select to preview"
        }
    }
    
    var actionButtonText: String {
        switch self {
        case .mergeContacts: "Merge"
        case .previewContacts: "Preview"
        }
    }
    
    var dismissButtonText: String {
        switch self {
        case .mergeContacts: "Cancel"
        case .previewContacts: "Cancel"
        }
    }
}

final class SelectedContactsBottomPopupViewController: BottomPopupViewController {
    static var idenfifier = "SelectedContactsBottomPopupViewController"
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    lazy var type: SelectedContactsType? = nil
    
    @IBOutlet weak var label: Semibold15LabelStyle!
    
    override var popupHeight: CGFloat { height ?? 400.0 }
    override var popupTopCornerRadius: CGFloat { topCornerRadius ?? 20.0 }
    override var popupPresentDuration: Double { presentDuration ?? 0.2 }
    override var popupDismissDuration: Double { dismissDuration ?? 0.2 }
    override var popupShouldDismissInteractivelty: Bool { shouldDismissInteractivelty ?? true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let type else { return }
        label.bind(text: type.title)
    }
}
