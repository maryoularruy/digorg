//
//  BestIcon.swift
//  Cleaner
//
//  Created by Elena Sedunova on 09.12.2024.
//

import UIKit

final class BestIcon: UIView {
    private lazy var starImageView: UIImageView = UIImageView(image: .blackStar)
    
    private lazy var bestLabel: UILabel = {
        let label = UILabel()
        label.text = "Best"
        label.textColor = .black
        label.font = .bold11
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        initConstraints()
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    private func initConstraints() {
        addSubviews([starImageView, bestLabel])
        
        NSLayoutConstraint.activate([
            starImageView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            starImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            starImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            starImageView.heightAnchor.constraint(equalToConstant: 14),
            starImageView.widthAnchor.constraint(equalToConstant: 14),
            
            bestLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 6),
            bestLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            bestLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor)
        ])
    }
}
