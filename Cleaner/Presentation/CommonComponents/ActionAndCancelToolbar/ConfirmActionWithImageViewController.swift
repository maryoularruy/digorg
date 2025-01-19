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
        case .createPasscode: "Create a Passcode to protect\n your private photos and videos"
        }
    }
    
    var actionButtonText: String {
        switch self {
        case .createPasscode: "Create Passcode"
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
    
    lazy var type: ConfirmActionWithImageType? = nil
    
    @IBOutlet weak var toolbar: ActionAndCancelToolbar!
    @IBOutlet weak var primaryLabel: Semibold15LabelStyle!
    @IBOutlet weak var secondaryLabel: Regular15LabelStyle!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.delegate = self
        guard let type else { return }
        imageView.image = type.image
        primaryLabel.bind(text: type.title)
        secondaryLabel.bind(text: type.subtitle)
        toolbar.actionButton.bind(text: type.actionButtonText)
        toolbar.dismissButton.bind(text: type.dismissButtonText)
    }
    
    override var popupHeight: CGFloat { height ?? 450.0 }
    override var popupTopCornerRadius: CGFloat { topCornerRadius ?? 20.0 }
    override var popupPresentDuration: Double { presentDuration ?? 0.2 }
    override var popupDismissDuration: Double { dismissDuration ?? 0.2 }
    override var popupShouldDismissInteractivelty: Bool { shouldDismissInteractivelty ?? true }
}

extension ConfirmActionWithImageViewController: ActionAndCancelToolbarDelegate {
    func tapOnAction() {
        popupDelegate?.bottomPopupDismissInteractionPercentChanged(from: 0, to: 100)
        dismiss(animated: true)
    }
    
    func tapOnCancel() {
        dismiss(animated: true)
    }
}
