//
//  RegularAssetsView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 04.12.2024.
//

import UIKit

final class RegularAssetsView: UIView {
    static var spacingBetweenAssets: CGFloat = 8
    static var assetsInRow: CGFloat = 3
    
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIImageView = UIImageView(image: .arrowBackIcon)
    private lazy var label: Semibold24LabelStyle = Semibold24LabelStyle()
    lazy var assetsCountLabel: Regular13LabelStyle = Regular13LabelStyle()
    
    lazy var assetsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = RegularAssetsView.spacingBetweenAssets
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(cellType: AssetCollectionViewCell.self)
        return collectionView
    }()
    
    private var type: RegularAssetsType
    
    init(_ type: RegularAssetsType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        type = .allPhotos
        super.init(coder: coder)
        setupView()
        initConstraints()
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
        arrowBack.contentMode = .center
        label.bind(text: type.title)
    }
    
    private func initConstraints() {
        addSubviews([contentView])
        contentView.addSubviews([arrowBack, label, assetsCountLabel, assetsCollectionView])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            arrowBack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            arrowBack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            arrowBack.heightAnchor.constraint(equalToConstant: 40),
            arrowBack.widthAnchor.constraint(equalToConstant: 40),
            
            label.topAnchor.constraint(equalTo: arrowBack.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            assetsCountLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6),
            assetsCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            assetsCollectionView.topAnchor.constraint(equalTo: assetsCountLabel.bottomAnchor, constant: 20),
            assetsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            assetsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            assetsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
