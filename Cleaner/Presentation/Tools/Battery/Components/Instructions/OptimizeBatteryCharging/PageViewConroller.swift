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
    
    var title: String {
        switch self {
        case .pageZero: "Open Settings"
        case .pageOne: "Go to Battery"
        case .pageTwo: "Tap Battery Health&Charging"
        case .pageThree: "Enable Optimize Battery Charging"
        }
    }
    
    var index: Int {
        switch self {
        case .pageZero: 0
        case .pageOne: 1
        case .pageTwo: 2
        case .pageThree: 3
        }
    }
}

final class PageViewConroller: UIViewController {
    var page: Page
    
    private lazy var label: Regular15LabelStyle = Regular15LabelStyle()
    
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
    }
    
    private func initContraints() {
        view.addSubviews([label])
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
