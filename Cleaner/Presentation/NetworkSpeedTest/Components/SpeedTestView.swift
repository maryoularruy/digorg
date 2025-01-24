//
//  SpeedTestView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 24.01.2025.
//

import UIKit

final class SpeedTestView: UIView {
    private lazy var progressBar: SpeedTestProgressBar = SpeedTestProgressBar(frame: CGRect(origin: .zero, size: CGSize(width: 288, height: 288)))
    
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
    
    func bind() {
        progressBar.progressAnimation(1.0)
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
        layer.cornerRadius = 20
        addShadows()
        
        //
        progressBar.backgroundColor = .acidGreen.withAlphaComponent(0.2)
        //
    }
    
    private func initConstraints() {
        addSubviews([progressBar])
        
        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: topAnchor),
            
//            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 42),
//            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -42),
            progressBar.heightAnchor.constraint(equalToConstant: 288),
            progressBar.widthAnchor.constraint(equalToConstant: 288),
            progressBar.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
