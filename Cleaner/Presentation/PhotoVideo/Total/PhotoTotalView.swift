//
//  PhotoTotalView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.11.2024.
//

import UIKit

final class PhotoTotalView: UIView {
    lazy var scroll: UIScrollView = scrollView
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIView = arrowBackButton
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.bind(text: "Photo Cleanup")
        return label
    }()
    
    lazy var progressView: ScanningGalleryProgressView = ScanningGalleryProgressView()
    lazy var progressViewHeight = progressView.heightAnchor.constraint(equalToConstant: ScanningGalleryProgressView.height)
    
    lazy var similarPhotosView = OneCategoryHorizontalView(.similarPhotos)
    lazy var duplicatePhotosView = OneCategoryHorizontalView(.duplicatePhotos)
    
    private lazy var similarAndDuplicatePhotosStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 8
        
        [similarPhotosView, duplicatePhotosView].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    lazy var livePhotosView = OneCategoryRectangularView(.live)
    lazy var blurryPhotosView = OneCategoryRectangularView(.blurry)
    
    private lazy var liveAndBlurryPhotosStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 8
        
        [livePhotosView, blurryPhotosView, UIView()].forEach { stackView.addArrangedSubview($0) }

        return stackView
    }()
    
    lazy var screenshotsView = OneCategoryVerticalView(.screenshots)
    
    private lazy var screenshotsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 0
        
        stackView.addArrangedSubview(screenshotsView)
        
        return stackView
    }()
    
    private lazy var liveBlurryScreenshotsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 0
        
        [liveAndBlurryPhotosStackView, screenshotsStackView, UIView()].forEach { stackView.addArrangedSubview($0) }
        [livePhotosView, blurryPhotosView, screenshotsView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            livePhotosView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.4),
            livePhotosView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5),
            
            blurryPhotosView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.4),
            blurryPhotosView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5),
            
            screenshotsView.heightAnchor.constraint(equalToConstant: 314),
            screenshotsView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5)
        ])
        
        return stackView
    }()
    
    lazy var portraitsPhotosView = OneCategoryHorizontalView(.portraits)
    lazy var allPhotosView = OneCategoryHorizontalView(.allPhotos)
    
    private lazy var portraintsAndAllPhotosStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 8
        
        [portraitsPhotosView, allPhotosView].forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    private lazy var oneCategoryViews: [OneCategoryProtocol] = [
        similarPhotosView,
        duplicatePhotosView,
        livePhotosView,
        blurryPhotosView,
        screenshotsView,
        portraitsPhotosView,
        allPhotosView
    ]
    
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
    
    func setupVisibility() {
        oneCategoryViews.forEach { $0.isHidden = $0.assets.isEmpty }
    }

    private func setupView() {
        backgroundColor = .paleGrey
        oneCategoryViews.forEach { $0.isHidden = true }
        
        if !UserDefaultsService.shared.isSubscriptionActive {
            duplicatePhotosView.setLocked()
        } else {
            duplicatePhotosView.unlock()
        }
    }
    
    private func initConstraints() {
        addSubviews([scroll])
        scroll.addSubviews([contentView])
        contentView.addSubviews([arrowBack, label, progressView, similarAndDuplicatePhotosStackView, liveBlurryScreenshotsStackView, portraintsAndAllPhotosStackView])
        
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
            
            arrowBack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            arrowBack.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            arrowBack.heightAnchor.constraint(equalToConstant: arrowBackButton.frame.height),
            arrowBack.widthAnchor.constraint(equalToConstant: arrowBackButton.frame.width),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            progressView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            progressViewHeight,
            
            similarAndDuplicatePhotosStackView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 16),
            similarAndDuplicatePhotosStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            similarAndDuplicatePhotosStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            liveBlurryScreenshotsStackView.topAnchor.constraint(equalTo: similarAndDuplicatePhotosStackView.bottomAnchor, constant: 8),
            liveBlurryScreenshotsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            liveBlurryScreenshotsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            portraintsAndAllPhotosStackView.topAnchor.constraint(equalTo: liveBlurryScreenshotsStackView.bottomAnchor, constant: 8),
            portraintsAndAllPhotosStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            portraintsAndAllPhotosStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            portraintsAndAllPhotosStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
