//
//  ConfirmActionViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 21.10.2024.
//

import UIKit
import BottomPopup

enum ConfirmActionType {
    case mergeContacts, deleteContacts, deleteEvents
    
    var title: String {
        switch self {
        case .mergeContacts: "Merge selected contacts?"
        case .deleteContacts: "Delete selected contacts?"
        case .deleteEvents: "Delete selected events?"
        }
    }
    
    var subtitle: String {
        switch self {
        case .mergeContacts: "This action cannot be restored"
        case .deleteContacts: "This action cannot be restored"
        case .deleteEvents: "This action cannot be restored"
        }
    }
}

final class ConfirmActionViewController: BottomPopupViewController {
    static var idenfifier = "ConfirmActionViewController"
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    lazy var actionButtonText: String = ""
    lazy var type: ConfirmActionType? = nil
    
    @IBOutlet weak var toolbar: ActionAndCancelToolbar!
    @IBOutlet weak var primaryLabel: Semibold15LabelStyle!
    @IBOutlet weak var secondaryLabel: Regular15LabelStyle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.delegate = self
        guard let type else { return }
        primaryLabel.bind(text: type.title)
        secondaryLabel.bind(text: type.subtitle)
        toolbar.actionButton.bind(text: actionButtonText)
    }
    
    override var popupHeight: CGFloat { height ?? 300.0 }
    override var popupTopCornerRadius: CGFloat { topCornerRadius ?? 20.0 }
    override var popupPresentDuration: Double { presentDuration ?? 0.2 }
    override var popupDismissDuration: Double { dismissDuration ?? 0.2 }
    override var popupShouldDismissInteractivelty: Bool { shouldDismissInteractivelty ?? true }
}

extension ConfirmActionViewController: ActionAndCancelToolbarDelegate {
    func tapOnAction() {
        popupDelegate?.bottomPopupDismissInteractionPercentChanged(from: 0, to: 100)
        dismiss(animated: true)
    }
    
    func tapOnCancel() {
        dismiss(animated: true)
    }
}
