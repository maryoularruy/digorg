//
//  OneCategoryHorizontalView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.11.2024.
//

import UIKit

enum OneCategoryHorizontalViewType {
    case similarPhotos, duplicatePhotos, portraits, allPhotos,
    duplicateVideos, superSizedVideos, allVideos
    
    var title: String {
        switch self {
        case .similarPhotos: "Similar Photos"
        case .duplicatePhotos: ""
        case .portraits: ""
        case .allPhotos: ""
        case .duplicateVideos: ""
        case .superSizedVideos: ""
        case .allVideos: ""
        }
    }
}

final class OneCategoryHorizontalView: UIView {
    private lazy var contentView: UIView = UIView()
    private lazy var label: Semibold15LabelStyle = Semibold15LabelStyle()
    
    private lazy var arrowForwardImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
        imageView.image = .arrowForwardBlue
        return imageView
    }()
    
    private lazy var itemsSizeLabel: Regular15LabelStyle = Regular15LabelStyle()
    private lazy var itemsCountLabel: Regular15LabelStyle = Regular15LabelStyle()
    
    lazy var itemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 78, height: 78)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = -36
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = UIColor. // Set background color
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    private var type: OneCategoryHorizontalViewType?
    
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
    
    func bind(_ type: OneCategoryHorizontalViewType) {
        self.type = type
        label.bind(text: type.title)
    }
    
    func bind(itemsCount: Int) {
        itemsCountLabel.bind(text: "\(itemsCount) File\(itemsCount == 1 ? "" :  "s")")
    }
    
    private func setupView() {
        contentView.backgroundColor = .paleGrey
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        addShadows()
    }
    
    private func initConstraints() {
        addSubviews([contentView])
        contentView.addSubviews([label, arrowForwardImageView, itemsCountLabel])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            arrowForwardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            arrowForwardImageView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            
            itemsCountLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
            itemsCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
}
