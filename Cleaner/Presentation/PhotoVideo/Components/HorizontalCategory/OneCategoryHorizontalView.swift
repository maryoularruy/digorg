//
//  OneCategoryHorizontalView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.11.2024.
//

import UIKit
import Photos

protocol OneCategoryHorizontalViewDelegate: AnyObject {
    func tapOnCategory(_ type: OneCategoryHorizontalViewType)
}

enum OneCategoryHorizontalViewType {
    case similarPhotos, duplicatePhotos, portraits, allPhotos,
    duplicateVideos, superSizedVideos, allVideos
    
    var title: String {
        switch self {
        case .similarPhotos: "Similar Photos"
        case .duplicatePhotos: "Duplicate Photos"
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
        layout.itemSize = TargetSize.small.size
        layout.minimumLineSpacing = -36
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(OneCategoryHorizontalCell.self, forCellWithReuseIdentifier: OneCategoryHorizontalCell.identifier)
        return collectionView
    }()
    
    private lazy var assetsCollectionViewHeight = assetsCollectionView.heightAnchor.constraint(equalToConstant: TargetSize.small.size.height)
    
    private var type: OneCategoryHorizontalViewType
    lazy var assets: [PHAsset] = [] {
        didSet {
            assetsCountLabel.bind(text: "\(assets.count) File\(assets.count == 1 ? "" :  "s")")
            assetsCollectionViewHeight.constant = assets.isEmpty ? 0 : TargetSize.small.size.height
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
    
    func setLocked() {
        arrowForwardImageView.image = .pro
        isUserInteractionEnabled = false
    }
    
    func unlock() {
        isUserInteractionEnabled = true
    }
    
    private func setupView() {
        contentView.backgroundColor = .paleGrey
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        addShadows()
        
        assetsCollectionView.delegate = self
        assetsCollectionView.dataSource = self
        
        label.bind(text: type.title)
        
        addTapGestureRecognizer { [weak self] in
            guard let self else { return }
            delegate?.tapOnCategory(type)
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
            assetsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            assetsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            assetsCollectionViewHeight
        ])
    }
}

extension OneCategoryHorizontalView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OneCategoryHorizontalCell.identifier, for: indexPath) as! OneCategoryHorizontalCell
        cell.bind(assets[indexPath.row].getAssetThumbnail(.small))
        return cell
    }
}
