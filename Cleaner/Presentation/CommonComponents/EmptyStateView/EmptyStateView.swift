//
//  EmptyStateView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 23.10.2024.
//

import UIKit

enum EmptyStateType {
    case noDuplicateNames, noNameContacts, emptySecretAlbum, emptySecretAlbumConfirmed, emptySecretContacts
    
    var title: String {
        switch self {
        case .noDuplicateNames: "No Duplicate Names"
        case .noNameContacts: "No contacts with the missing names"
        case .emptySecretAlbum: "No secret photos or videos, click “+” button to add some"
        case .emptySecretAlbumConfirmed: "No secret photos or videos"
        case .emptySecretContacts: "No secret contacts, click “+” button\n to add some"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .noDuplicateNames: .people
        case .noNameContacts: .people
        case .emptySecretAlbum: .mediaIcon
        case .emptySecretAlbumConfirmed: .mediaIcon
        case .emptySecretContacts: .people
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
