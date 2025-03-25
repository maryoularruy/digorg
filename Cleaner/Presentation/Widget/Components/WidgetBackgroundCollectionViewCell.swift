//
//  WidgetBackgroundCollectionViewCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 24.03.2025.
//

import UIKit
import Reusable

struct WidgetBackground {
    let hex: String
    let color: UIColor
    let isSelected: Bool
}

final class WidgetBackgroundCollectionViewCell: UICollectionViewCell, Reusable {
    static var size: CGSize = CGSize(width: 46, height: 46)
    
    private lazy var innerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 3
        return view
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
        innerView.backgroundColor = widgetBackground.color
        innerView.layer.borderColor = UIColor(resource: widgetBackground.color == .paleGrey ? .middleGrey : .paleGrey).cgColor
        
        if widgetBackground.color == .paleGrey {
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor(resource: .middleGrey).cgColor
        }
        
        innerView.isHidden = !widgetBackground.isSelected
    }
    
    private func setupView() {
        contentView.layer.cornerRadius = 14
        contentView.clipsToBounds = true
    }
    
    private func initConstraints() {
        contentView.addSubviews([innerView])
        
        NSLayoutConstraint.activate([
            innerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            innerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            innerView.heightAnchor.constraint(equalToConstant: 40),
            innerView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
