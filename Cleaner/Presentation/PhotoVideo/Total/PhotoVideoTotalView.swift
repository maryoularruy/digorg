//
//  PhotoVideoTotalView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.11.2024.
//

import UIKit

final class PhotoVideoTotalView: UIView {
    private lazy var scroll: UIScrollView = scrollView
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.bind(text: "Photo Cleanup")
        return label
    }()
    
    lazy var similarPhotosView = OneCategoryHorizontalView(.similarPhotos)
    lazy var duplicatePhotosView = OneCategoryHorizontalView(.duplicatePhotos)
    lazy var portraitsPhotosView = OneCategoryHorizontalView(.portraits)
    lazy var allPhotosView = OneCategoryHorizontalView(.allPhotos)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        initConstraints()
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
    }
    
    private func initConstraints() {
        addSubviews([scroll])
        scroll.addSubviews([contentView])
        contentView.addSubviews([arrowBack, label, similarPhotosView])
        
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scroll.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scroll.widthAnchor, constant: -32),
            
            arrowBack.topAnchor.constraint(equalTo: contentView.topAnchor),
            arrowBack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -16),
            arrowBack.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBack.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
//            arrowBack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            similarPhotosView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            similarPhotosView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            similarPhotosView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            similarPhotosView.heightAnchor.constraint(equalToConstant: 200),
            similarPhotosView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
