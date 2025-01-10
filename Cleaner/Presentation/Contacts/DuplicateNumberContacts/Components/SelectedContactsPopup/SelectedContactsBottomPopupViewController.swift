//
//  SelectedContactsBottomPopupViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 03.01.2025.
//

import UIKit
import BottomPopup
import Contacts

protocol SelectedContactsBottomPopupViewControllerDelegate: AnyObject {
    func tapOnMerge(activeChoice: Int, row: Int)
}

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
    
    weak var delegate: SelectedContactsBottomPopupViewControllerDelegate?
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    lazy var type: SelectedContactsType? = nil
    lazy var contacts: [CNContact] = []
    lazy var position: Int = 0
    
    private var activeChoice: Int = 0 {
        didSet {
            contactsStackView.arrangedSubviews.forEach { subview in
                subview.backgroundColor = subview.tag == activeChoice ? .lightBlue : .clear
            }
        }
    }
    
    @IBOutlet weak var label: Semibold15LabelStyle!
    @IBOutlet weak var toolbar: ActionAndCancelToolbar!
    @IBOutlet weak var contactsStackView: UIStackView!
    
    override var popupHeight: CGFloat { height ?? 300.0 }
    override var popupTopCornerRadius: CGFloat { topCornerRadius ?? 20.0 }
    override var popupPresentDuration: Double { presentDuration ?? 0.2 }
    override var popupDismissDuration: Double { dismissDuration ?? 0.2 }
    override var popupShouldDismissInteractivelty: Bool { shouldDismissInteractivelty ?? true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.delegate = self
        guard let type else { return }
        label.bind(text: type.title)
        toolbar.actionButton.bind(text: type.actionButtonText)
        toolbar.dismissButton.bind(text: type.dismissButtonText)
        
        for i in 0..<contacts.count {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: contactsStackView.frame.width, height: 50))
            view.layer.cornerRadius = 20
            
            let label = Regular15LabelStyle()
            let fullName = contacts[i].fullName
            if fullName.isEmpty || fullName == "" || fullName == " " {
                let missingText = "Name is missing"
                let attributes = [NSAttributedString.Key.foregroundColor : UIColor.darkGrey]
                let attributedText = NSAttributedString(string: missingText, attributes: attributes)
                label.attributedText = attributedText
            } else {
                label.attributedText = nil
                label.text = fullName
            }
            
            view.addSubviews([label])
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            
            view.tag = i
            view.addTapGestureRecognizer { [weak self] in
                self?.activeChoice = i
            }
            
            contactsStackView.addArrangedSubview(view)
        }
        activeChoice = 0
    }
    
    func calcPopupHeight() {
        let h = if contacts.isEmpty {
            227
        } else {
            contacts.count * 50 + (8 * (contacts.count - 1)) + 227
        }
        height = CGFloat(h)
    }
    
    deinit {
        print("SelectedContactsBottomPopupViewController deinit")
    }
}

extension SelectedContactsBottomPopupViewController: ActionAndCancelToolbarDelegate {
    func tapOnAction() {
        delegate?.tapOnMerge(activeChoice: activeChoice, row: position)
        dismiss(animated: true)
    }
    
    func tapOnCancel() {
        dismiss(animated: true)
    }
}
