//
//  VideoTotalView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 02.12.2024.
//

import UIKit

final class VideoTotalView: UIView {
    lazy var scroll: UIScrollView = scrollView
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIImageView = UIImageView(image: .arrowBackIcon)
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.bind(text: "Videos Cleanup")
        return label
    }()
    
    lazy var progressView: ScanningGalleryProgressView = ScanningGalleryProgressView()
    lazy var progressViewHeight = progressView.heightAnchor.constraint(equalToConstant: ScanningGalleryProgressView.height)
    
    lazy var duplicateVideosView = OneCategoryHorizontalView(.duplicateVideos)
    lazy var superSizedVideosView = OneCategoryHorizontalView(.superSizedVideos)
    lazy var allVideosView = OneCategoryHorizontalView(.allVideos)
    
    private lazy var categoriesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 8
        
        oneCategoryViews.forEach { stackView.addArrangedSubview($0) }
        
        return stackView
    }()
    
    private lazy var oneCategoryViews: [OneCategoryProtocol] = [
        duplicateVideosView,
        superSizedVideosView,
        allVideosView
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
        arrowBack.contentMode = .center
        setupVisibility()
    }
    
    private func initConstraints() {
        addSubviews([scroll])
        scroll.addSubviews([contentView])
        contentView.addSubviews([arrowBack, label, progressView, categoriesStackView])
        
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
            arrowBack.heightAnchor.constraint(equalToConstant: 40),
            arrowBack.widthAnchor.constraint(equalToConstant: 40),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            progressView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            progressViewHeight,
            
            categoriesStackView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 16),
            categoriesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoriesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoriesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
       ])
    }
}
