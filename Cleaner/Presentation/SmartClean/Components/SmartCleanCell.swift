//
//  SmartCleanCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 06.02.2025.
//

import UIKit

protocol SmartCleanCellDelegate: AnyObject {
    func tapOnManageButton(_ type: SmartCleanCellType)
}

enum SmartCleanCellType {
    case calendar, contacts, duplicatePhotos, screenshots, duplicatesVideos
    
    var title: String {
        switch self {
        case .calendar: "Calendar"
        case .contacts: "Contacts"
        case .duplicatePhotos: "Duplicate Photos"
        case .screenshots: "Screenshots"
        case .duplicatesVideos: "Duplicate Videos"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .calendar: UIImage(resource: .calendar)
        case .contacts: UIImage(resource: .contactsPurple)
        case .duplicatePhotos: UIImage(resource: .duplicatePhotos)
        case .screenshots: UIImage(resource: .screenshots)
        case .duplicatesVideos: UIImage(resource: .duplicateVideos)
        }
    }
    
    var isShowAssets: Bool {
        switch self {
        case .calendar: false
        case .contacts: false
        case .duplicatePhotos: true
        case .screenshots: true
        case .duplicatesVideos: true
        }
    }
}

final class SmartCleanCell: UIView {
    weak var delegate: SmartCleanCellDelegate?
    
    private let type: SmartCleanCellType
    
    private lazy var imageView: UIImageView = UIImageView(image: type.icon)
    
    private lazy var title: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.bind(text: type.title)
        return label
    }()
    
    private lazy var markRedImageView: UIImageView = {
        let imageView = UIImageView(image: .redMark)
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var spinner: CircularLoaderView = CircularLoaderView(frame: CGRect(origin: .zero, size: CGSize(width: 26, height: 26)))
    
    private lazy var manageButton: Medium12ButtonStyle = {
        let button = Medium12ButtonStyle()
        button.layer.cornerRadius = 16
        button.isHidden = true
        button.bind(text: "Manage")
        return button
    }()
    
    init(type: SmartCleanCellType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(itemsCount: Int) {
        manageButton.isHidden = false
        markRedImageView.isHidden = itemsCount == 0
        spinner.endAnimation()
    }
    
    func startSpinner() {
        [manageButton, markRedImageView].forEach { $0.isHidden = true }
        spinner.startAnimation()
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
        layer.cornerRadius = 20
        addShadows()
        
        manageButton.addTapGestureRecognizer { [weak self] in
            guard let self else { return }
            delegate?.tapOnManageButton(type)
        }
    }
    
    private func initConstraints() {
        addSubviews([imageView, title, markRedImageView, spinner, manageButton])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            //
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            //
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            
            title.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            title.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            markRedImageView.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 8),
            markRedImageView.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            
            spinner.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            spinner.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            spinner.heightAnchor.constraint(equalToConstant: 26),
            spinner.widthAnchor.constraint(equalToConstant: 26),
            
            manageButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            manageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            manageButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
}
