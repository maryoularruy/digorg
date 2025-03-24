//
//  WidgetBackgroundCollectionViewCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 24.03.2025.
//

import UIKit
import Reusable

struct WidgetBackground {
    let id: Int
    let color: UIColor
    let selectedImage: UIImage
    let isSelected: Bool
}

final class WidgetBackgroundCollectionViewCell: UICollectionViewCell, Reusable {
    static var size: CGSize = CGSize(width: 46, height: 46)
    
    private lazy var colorImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: WidgetBackgroundCollectionViewCell.size))
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
    
    func bind(widgetBackground: WidgetBackground) {
        contentView.backgroundColor = widgetBackground.color
        colorImageView.image = widgetBackground.selectedImage
        colorImageView.isHidden = !widgetBackground.isSelected
    }
    
    private func setupView() {
        contentView.layer.cornerRadius = 14
        contentView.clipsToBounds = true
    }
    
    private func initConstraints() {
        contentView.addSubviews([colorImageView])
        
        NSLayoutConstraint.activate([
            colorImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorImageView.heightAnchor.constraint(equalToConstant: SmartCleanCollectionViewCell.size.height),
            colorImageView.widthAnchor.constraint(equalToConstant: SmartCleanCollectionViewCell.size.width)
        ])
    }
}
