//
//  VideoTotalView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 02.12.2024.
//

import UIKit

final class VideoTotalView: UIView {
    private lazy var scroll: UIScrollView = scrollView
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIImageView = UIImageView(image: .arrowBackIcon)
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.bind(text: "Videos Cleanup")
        return label
    }()
    
    lazy var duplicateVideosView = OneCategoryHorizontalView(.duplicateVideos)
    lazy var superSizedVideosView = OneCategoryHorizontalView(.superSizedVideos)
    lazy var allVideosView = OneCategoryHorizontalView(.allVideos)
    
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
        arrowBack.contentMode = .center
    }
    
    private func initConstraints() {
        addSubviews([scroll])
        scroll.addSubviews([contentView])
        contentView.addSubviews([arrowBack, label, duplicateVideosView, superSizedVideosView, allVideosView])
        
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
            
            duplicateVideosView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            duplicateVideosView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            duplicateVideosView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            superSizedVideosView.topAnchor.constraint(equalTo: duplicateVideosView.bottomAnchor, constant: 8),
            superSizedVideosView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            superSizedVideosView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            allVideosView.topAnchor.constraint(equalTo: superSizedVideosView.bottomAnchor, constant: 8),
            allVideosView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            allVideosView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            allVideosView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
       ])
    }
}
