//
//  OneCategoryHorizontalCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 27.11.2024.
//

import UIKit

final class OneCategoryHorizontalCell: UICollectionViewCell {
    static var identifier = "OneCategoryHorizontalCell"
    
    lazy var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        initConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        initConstraints()
    }
    
    func bind(_ image: UIImage) {
        imageView.setImage(image)
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGrey.cgColor
        contentView.clipsToBounds = true
    }
    
    private func initConstraints() {
        contentView.addSubviews([imageView])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
