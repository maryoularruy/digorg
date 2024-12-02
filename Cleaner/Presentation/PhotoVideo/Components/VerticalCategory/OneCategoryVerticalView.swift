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
    
    private lazy var contentView: UIView = UIView()
    private lazy var label: Semibold15LabelStyle = Semibold15LabelStyle()
    
    private lazy var arrowForwardImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
        imageView.image = .arrowForwardBlue
        return imageView
    }()
    
    private lazy var assetsSizeLabel: Regular15LabelStyle = Regular15LabelStyle()
    private lazy var assetsCountLabel: Regular15LabelStyle = Regular15LabelStyle()
    
    private var type: OneCategoryVerticalViewType
    lazy var assets: [PHAsset] = [] {
        didSet {
            assetsCountLabel.bind(text: "\(assets.count) File\(assets.count == 1 ? "" :  "s")")
//            assetsCollectionViewHeight.constant = assets.isEmpty ? 0 : TargetSize.small.size.height
//            assetsCollectionView.reloadData()
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
        
//        assetsCollectionView.delegate = self
//        assetsCollectionView.dataSource = self
        
        label.bind(text: type.title)
        
        addTapGestureRecognizer { [weak self] in
            guard let self else { return }
            delegate?.tapOnCategory(type)
        }
    }
    
    private func initConstraints() {
        addSubviews([contentView])
        contentView.addSubviews([label, arrowForwardImageView, assetsCountLabel])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            arrowForwardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -9),
            arrowForwardImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            
            assetsCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            assetsCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -36),
            
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: assetsCountLabel.bottomAnchor, constant: -7)
        ])
    }
}
