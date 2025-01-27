//
//  ArrowAndMbpsView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 24.01.2025.
//

import UIKit

final class ArrowAndMbpsView: UIView {
    lazy var arrowImageView = UIImageView(image: .downloadBlack)
    
    private lazy var mpbsLabel: Semibold15LabelStyle = {
        let label = Semibold15LabelStyle()
        label.bind(text: "Mbps")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initConstraints()
    }
    
    private func initConstraints() {
        addSubviews([arrowImageView, mpbsLabel])
        
        NSLayoutConstraint.activate([
            arrowImageView.topAnchor.constraint(equalTo: topAnchor),
            arrowImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            arrowImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            
            mpbsLabel.topAnchor.constraint(equalTo: topAnchor),
            mpbsLabel.leadingAnchor.constraint(equalTo: arrowImageView.trailingAnchor, constant: 8),
            mpbsLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
