//
//  RegularAssetsView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 04.12.2024.
//

import UIKit

final class RegularAssetsView: UIView {
    private lazy var contentView: UIView = UIView()
    lazy var arrowBack: UIImageView = UIImageView(image: .arrowBackIcon)
    private lazy var label: Semibold24LabelStyle = Semibold24LabelStyle()
    private lazy var assetsCountLabel: Regular13LabelStyle = Regular13LabelStyle()
    
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
    
    func bind(assetsCount: Int) {
        assetsCountLabel.bind(text: "\(assetsCount) file\(assetsCount == 1 ? "" : "s")")
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
        arrowBack.contentMode = .center
        label.bind(text: type.title)
    }
    
    private func initConstraints() {
        addSubviews([contentView])
        contentView.addSubviews([arrowBack, label, assetsCountLabel])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            arrowBack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            arrowBack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            arrowBack.heightAnchor.constraint(equalToConstant: 40),
            arrowBack.widthAnchor.constraint(equalToConstant: 40),
            
            label.topAnchor.constraint(equalTo: arrowBack.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            assetsCountLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6),
            assetsCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            
        ])
    }
}
