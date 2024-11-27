//
//  OneCategoryHorizontalView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.11.2024.
//

import UIKit
import Photos

protocol OneCategoryHorizontalViewDelegate: AnyObject {
    func tapOnCategory()
}

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
    weak var delegate: OneCategoryHorizontalViewDelegate?
    
    private lazy var contentView: UIView = UIView()
    private lazy var label: Semibold15LabelStyle = Semibold15LabelStyle()
    
    private lazy var arrowForwardImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
        imageView.image = .arrowForwardBlue
        return imageView
    }()
    
    private lazy var assetsSizeLabel: Regular15LabelStyle = Regular15LabelStyle()
    private lazy var assetsCountLabel: Regular15LabelStyle = Regular15LabelStyle()
    
    lazy var assetsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 78, height: 78)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = -36
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = UIColor. // Set background color
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OneCategoryHorizontalCell.self, forCellWithReuseIdentifier: OneCategoryHorizontalCell.identifier)
        return collectionView
    }()
    
    private var type: OneCategoryHorizontalViewType
    lazy var assets: [PHAsset] = [] {
        didSet {
            assetsCountLabel.bind(text: "\(assets.count) File\(assets.count == 1 ? "" :  "s")")
            assetsCollectionView.reloadData()
        }
    }
    
    init(_ type: OneCategoryHorizontalViewType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        type = .similarPhotos
        super.init(coder: coder)
    }
    
    private func setupView() {
        contentView.backgroundColor = .paleGrey
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        addShadows()
        
        label.bind(text: type.title)
        
        addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnCategory()
        }
    }
    
    private func initConstraints() {
        addSubviews([contentView])
        contentView.addSubviews([label, arrowForwardImageView, assetsCountLabel, assetsCollectionView])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            arrowForwardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            arrowForwardImageView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            
            assetsCountLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
            assetsCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            assetsCollectionView.topAnchor.constraint(equalTo: assetsCountLabel.bottomAnchor, constant: 14),
            assetsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            assetsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

extension OneCategoryHorizontalView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OneCategoryHorizontalCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.bind(assets[indexPath.row].getAssetThumbnail(.small))
        return cell
    }
}
