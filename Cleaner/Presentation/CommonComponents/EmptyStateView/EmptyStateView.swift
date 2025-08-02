//
//  EmptyStateView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 23.10.2024.
//

import UIKit

enum EmptyStateType {
    case noDuplicateNames, noDuplicateNumbers, noNameContacts, noEvents, emptySecureVault, emptySecureVaultConfirmed, emptySecureContacts, empty
    
    var title: String {
        switch self {
        case .noDuplicateNames: "No Duplicate Names"
        case .noDuplicateNumbers: "No Duplicate Numbers"
        case .noNameContacts: "No contacts with the missing names"
        case .noEvents: "No Events"
        case .emptySecureVault: "No secure files, click \"+\" button to add some"
        case .emptySecureVaultConfirmed: "No secure files"
        case .emptySecureContacts: "No secure contacts, click \"+\" button\n to add some"
        case .empty: "Empty"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .noDuplicateNames: .people
        case .noDuplicateNumbers: .people
        case .noNameContacts: .people
        case .noEvents: .event
        case .emptySecureVault: .mediaIcon
        case .emptySecureVaultConfirmed: .mediaIcon
        case .emptySecureContacts: .people
        case .empty: .mediaIcon
        }
    }
}

final class EmptyStateView: UIView {
    static var myFrame = CGRect(origin: .zero, size: CGSize(width: 290, height: 170))
    private var nibName = "EmptyStateView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: Regular15LabelStyle!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func bind(type: EmptyStateType) {
        image.image = type.icon
        title.text = type.title
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(nibName, owner: self)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
