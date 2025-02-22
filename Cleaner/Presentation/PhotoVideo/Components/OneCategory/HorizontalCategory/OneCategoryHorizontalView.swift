//
//  OneCategoryHorizontalView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.11.2024.
//

import UIKit
import Photos

protocol OneCategoryHorizontalViewDelegate: AnyObject {
    func tapOnCategory(_ type: OneCategory.HorizontalViewType)
}

final class OneCategoryHorizontalView: UIView, OneCategoryProtocol {
    var type: Any
    weak var delegate: OneCategoryHorizontalViewDelegate?
    
    private lazy var contentView: UIView = UIView()
    private lazy var label: Semibold15LabelStyle = Semibold15LabelStyle()
    
    private lazy var arrowForwardImageView: UIImageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
    
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
        collectionView.register(OneCategoryCell.self, forCellWithReuseIdentifier: OneCategoryCell.identifier)
        return collectionView
    }()
    
    private lazy var assetsCollectionViewHeight = assetsCollectionView.heightAnchor.constraint(equalToConstant: TargetSize.small.size.height)
    
    lazy var assets: [PHAsset] = [] {
        didSet {
            assets.getAssetsSize { size in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    assetsSizeLabel.bind(text: size.convertToString())
                    assetsCountLabel.bind(text: "\(assets.count) File\(assets.count == 1 ? "" :  "s")")
                    assetsCollectionViewHeight.constant = assets.isEmpty ? 0 : TargetSize.small.size.height
                    assetsCollectionView.reloadData()
                }
            }
        }
    }
    
    init(_ type: OneCategory.HorizontalViewType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setLocked() {
        arrowForwardImageView.image = .premiumIcon
        isUserInteractionEnabled = false
    }
    
    func unlock() {
        arrowForwardImageView.setImage(.arrowForwardBlue)
        isUserInteractionEnabled = true
    }
    
    private func setupView() {
        guard let type = type as? OneCategory.HorizontalViewType else { return }
        
        contentView.backgroundColor = .paleGrey
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        addShadows()
        
        arrowForwardImageView.image = if type == .duplicateVideos || type == .superSizedVideos || type == .allVideos {
            .arrowForwardGrey
        } else {
            .arrowForwardBlue
        }
        
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
        contentView.addSubviews([label, arrowForwardImageView, assetsSizeLabel, assetsCountLabel, assetsCollectionView])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            arrowForwardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            arrowForwardImageView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            
            assetsSizeLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
            assetsSizeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            assetsCountLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
            assetsCountLabel.leadingAnchor.constraint(equalTo: assetsSizeLabel.trailingAnchor, constant: 10),
            
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
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OneCategoryCell.identifier, for: indexPath) as! OneCategoryCell
        cell.bind(assets[indexPath.row].getAssetThumbnail(TargetSize.small.size))
        return cell
    }
}
