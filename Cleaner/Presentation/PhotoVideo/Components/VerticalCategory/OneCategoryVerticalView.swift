//
//  OneCategoryVerticalView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 02.12.2024.
//

import UIKit
import Photos

protocol OneCategoryVerticalViewDelegate: AnyObject {
    func tapOnCategory(_ type: OneCategoryVerticalViewType)
}

enum OneCategoryVerticalViewType {
    case screenshots
    
    var title: String {
        switch self {
        case .screenshots: "Screenshots"
        }
    }
}

final class OneCategoryVerticalView: UIView {
    weak var delegate: OneCategoryVerticalViewDelegate?
    
    private static var size = CGSize(width: 46, height: 88)
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
        layout.itemSize = OneCategoryVerticalView.size
        layout.minimumLineSpacing = -23
        layout.minimumInteritemSpacing = -28
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(OneCategoryCell.self, forCellWithReuseIdentifier: OneCategoryCell.identifier)
        return collectionView
    }()
    
    private var type: OneCategoryVerticalViewType
    lazy var assets: [PHAsset] = [] {
        didSet {
            assetsCountLabel.bind(text: "\(assets.count) File\(assets.count == 1 ? "" :  "s")")
            assetsCollectionView.reloadData()
        }
    }
    
    init(_ type: OneCategoryVerticalViewType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        type = .screenshots
        super.init(coder: coder)
    }
    
    private func setupView() {
        contentView.backgroundColor = .paleGrey
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        addShadows()
        
        assetsSizeLabel.setGreyTextColor()
        assetsCountLabel.setGreyTextColor()
        
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
        contentView.addSubviews([assetsCollectionView, label, arrowForwardImageView, assetsCountLabel])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            assetsCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 19),
            assetsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            assetsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11),
            
            label.topAnchor.constraint(equalTo: assetsCollectionView.bottomAnchor, constant: 22),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            assetsCountLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 7),
            assetsCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            arrowForwardImageView.topAnchor.constraint(equalTo: assetsCountLabel.bottomAnchor, constant: 2),
            arrowForwardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -9),
            arrowForwardImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14)
        ])
    }
}

extension OneCategoryVerticalView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OneCategoryCell.identifier, for: indexPath) as! OneCategoryCell
        cell.layer.cornerRadius = 8
        cell.bind(assets[indexPath.row].getAssetThumbnail(OneCategoryVerticalView.size))
        return cell
    }
}
