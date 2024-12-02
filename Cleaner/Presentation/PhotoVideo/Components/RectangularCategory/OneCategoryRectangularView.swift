//
//  OneCategoryRectangularView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 30.11.2024.
//

import UIKit
import Photos

protocol OneCategoryRectangularViewDelegate: AnyObject {
    func tapOnCategory(_ type: OneCategoryRectangularViewType)
}

enum OneCategoryRectangularViewType {
    case live, blurry
    
    var title: String {
        switch self {
        case .live: "Live"
        case .blurry: "Blurry"
        }
    }
}

final class OneCategoryRectangularView: UIView {
    static var size = CGSize(width: 168, height: 153)
    weak var delegate: OneCategoryRectangularViewDelegate?
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private lazy var backgroundImageView = UIImageView(image: .liveViewBackground)
    
    private lazy var label: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.textColor = .paleGrey
        return label
    }()
    
    private lazy var assetsSizeLabel: Regular15LabelStyle = {
        let label = Regular15LabelStyle()
        label.textColor = .lightGrey
        return label
    }()
    
    private lazy var assetsCountLabel: Regular15LabelStyle = {
        let label = Regular15LabelStyle()
        label.textColor = .lightGrey
        return label
    }()
    
    private lazy var arrowForwardImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
        imageView.image = .arrowForwardWhite
        return imageView
    }()
    
    private var type: OneCategoryRectangularViewType
    lazy var assets: [PHAsset] = [] {
        didSet {
            assetsCountLabel.bind(text: "\(assets.count) File\(assets.count == 1 ? "" :  "s")")
        }
    }
    
    init(_ type: OneCategoryRectangularViewType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        type = .blurry
        super.init(coder: coder)
    }
    
    private func setupView() {
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        addShadows()
        
        label.bind(text: type.title)
        
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
