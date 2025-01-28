//
//  PageViewConroller.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.11.2024.
//

import UIKit

protocol PageProtocol: CaseIterable {
    var index: Int { get }
    var title: String { get }
    var description: String { get }
    var image: UIImage { get }
}

final class PageViewConroller: UIViewController {
    var page: any PageProtocol
    
    private lazy var label: Regular15LabelStyle = Regular15LabelStyle()
    private lazy var instructionsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(with page: any PageProtocol) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
        bind(page)
        initContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(_ page: any PageProtocol) {
        label.bind(text: page.description)
        instructionsImageView.image = page.image
    }
    
    private func initContraints() {
        view.addSubviews([label, instructionsImageView])
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            instructionsImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            instructionsImageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -33),
            instructionsImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
