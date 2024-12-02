//
//  PhotoTotalView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.11.2024.
//

import UIKit

final class PhotoTotalView: UIView {
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
    lazy var livePhotosView = OneCategoryRectangularView(.live)
    lazy var blurryPhotosView = OneCategoryRectangularView(.blurry)
    lazy var screenshotsView = OneCategoryVerticalView(.screenshots)
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
        if !UserDefaultsService.shared.isSubscriptionActive {
            duplicatePhotosView.setLocked()
        } else {
            duplicatePhotosView.unlock()
        }
    }
    
    private func initConstraints() {
        addSubviews([scroll])
        scroll.addSubviews([contentView])
        contentView.addSubviews([arrowBack, label, similarPhotosView, duplicatePhotosView, livePhotosView, blurryPhotosView, screenshotsView, portraitsPhotosView, allPhotosView])
        
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scroll.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -90),
            contentView.widthAnchor.constraint(equalTo: scroll.widthAnchor, constant: -32),
            
            arrowBack.topAnchor.constraint(equalTo: contentView.topAnchor),
            arrowBack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -16),
            arrowBack.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBack.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            similarPhotosView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            similarPhotosView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            similarPhotosView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            duplicatePhotosView.topAnchor.constraint(equalTo: similarPhotosView.bottomAnchor, constant: 8),
            duplicatePhotosView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            duplicatePhotosView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            livePhotosView.topAnchor.constraint(equalTo: duplicatePhotosView.bottomAnchor, constant: 16),
            livePhotosView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            livePhotosView.heightAnchor.constraint(equalToConstant: OneCategoryRectangularView.size.height),
            livePhotosView.widthAnchor.constraint(equalToConstant: OneCategoryRectangularView.size.width),
            
            blurryPhotosView.topAnchor.constraint(equalTo: livePhotosView.bottomAnchor, constant: 8),
            blurryPhotosView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurryPhotosView.heightAnchor.constraint(equalToConstant: OneCategoryRectangularView.size.height),
            blurryPhotosView.widthAnchor.constraint(equalToConstant: OneCategoryRectangularView.size.width),
            
            screenshotsView.topAnchor.constraint(equalTo: duplicatePhotosView.bottomAnchor, constant: 16),
            screenshotsView.leadingAnchor.constraint(equalTo: livePhotosView.trailingAnchor, constant: 8),
            screenshotsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            screenshotsView.bottomAnchor.constraint(equalTo: blurryPhotosView.bottomAnchor),
            
            portraitsPhotosView.topAnchor.constraint(equalTo: blurryPhotosView.bottomAnchor, constant: 16),
            portraitsPhotosView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            portraitsPhotosView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            allPhotosView.topAnchor.constraint(equalTo: portraitsPhotosView.bottomAnchor, constant: 8),
            allPhotosView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            allPhotosView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            allPhotosView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
