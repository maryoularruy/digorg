//
//  SmartCleanCollectionViewCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 06.02.2025.
//

import UIKit
import Reusable

final class SmartCleanCollectionViewCell: UICollectionViewCell, Reusable {
    static var size: CGSize = TargetSize.smartClean.size
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: SmartCleanCollectionViewCell.size))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(image: UIImage) {
        imageView.image = image
    }
    
    private func setupView() {
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    private func initConstraints() {
        contentView.addSubviews([imageView])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: SmartCleanCollectionViewCell.size.height),
            imageView.widthAnchor.constraint(equalToConstant: SmartCleanCollectionViewCell.size.width)
        ])
    }
}
