//
//  OneCategoryRectangularView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 30.11.2024.
//

import UIKit
import Photos

protocol OneCategoryRectangularViewDelegate: AnyObject {
    func tapOnCategory(_ type: OneCategory.RectangularViewType)
}

final class OneCategoryRectangularView: UIView, OneCategoryProtocol {
    var type: Any
    static var size = CGSize(width: 168, height: 153)
    weak var delegate: OneCategoryRectangularViewDelegate?
    
    private lazy var contentView: UIView = UIView()
    private lazy var backgroundImageView = UIImageView()
    private lazy var label: Semibold15LabelStyle = Semibold15LabelStyle()
    private lazy var assetsSizeLabel: Regular15LabelStyle = Regular15LabelStyle()
    private lazy var assetsCountLabel: Regular15LabelStyle = Regular15LabelStyle()
    private lazy var arrowForwardImageView: UIImageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
    
    lazy var assets: [PHAsset] = [] {
        didSet {
            assetsCountLabel.bind(text: "\(assets.count) File\(assets.count == 1 ? "" :  "s")")
        }
    }
    
    init(_ type: OneCategory.RectangularViewType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        guard let type = type as? OneCategory.RectangularViewType else { return }
        
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        addShadows()
        
        switch type {
        case .live:
            label.textColor = .paleGrey
            label.bind(text: type.title)
            assetsSizeLabel.textColor = .lightGrey
            assetsCountLabel.textColor = .lightGrey
            contentView.backgroundColor = .blue
            arrowForwardImageView.image = .arrowForwardWhite
            backgroundImageView.image = .liveViewBackground
            
        case .blurry:
            label.textColor = .black
            label.bind(text: type.title)
            assetsSizeLabel.textColor = .darkGrey
            assetsCountLabel.textColor = .darkGrey
            contentView.backgroundColor = .paleGrey
            arrowForwardImageView.image = .arrowForwardBlue
            backgroundImageView.image = .blurryViewBackground
        }
        
        addTapGestureRecognizer { [weak self] in
            guard let self else { return }
            delegate?.tapOnCategory(type)
        }
    }
    
    private func initConstraints() {
        addSubviews([contentView])
        contentView.addSubviews([backgroundImageView, label, arrowForwardImageView, assetsCountLabel])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 74),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            arrowForwardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -9),
            arrowForwardImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            
            assetsCountLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 7),
            assetsCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
}
