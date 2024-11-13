//
//  PageViewConroller.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.11.2024.
//

import UIKit

enum Page: CaseIterable {
    case pageZero
    case pageOne
    case pageTwo
    case pageThree
    
    var index: Int {
        switch self {
        case .pageZero: 0
        case .pageOne: 1
        case .pageTwo: 2
        case .pageThree: 3
        }
    }
    
    var title: String {
        switch self {
        case .pageZero: "Open Settings"
        case .pageOne: "Go to Battery"
        case .pageTwo: "Tap Battery Health&Charging"
        case .pageThree: "Enable Optimize Battery Charging"
        }
    }
    
    var image: UIImage {
        switch self {
        case .pageZero: .batteryInstructions1
        case .pageOne: .batteryInstructions2
        case .pageTwo: .batteryInstructions3
        case .pageThree: .batteryInstructions4
        }
    }
}

final class PageViewConroller: UIViewController {
    var page: Page
    
    private lazy var label: Regular15LabelStyle = Regular15LabelStyle()
    private lazy var instructionsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(with page: Page) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
        bind(page)
        initContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(_ page: Page) {
        label.bind(text: page.title)
        instructionsImageView.image = page.image
    }
    
    private func initContraints() {
        view.addSubviews([label, instructionsImageView])
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            instructionsImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            instructionsImageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -30),
            instructionsImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
