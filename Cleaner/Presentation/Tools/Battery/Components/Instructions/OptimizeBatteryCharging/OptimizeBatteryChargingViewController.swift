//
//  OptimizeBatteryChargingViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.11.2024.
//

import UIKit

enum Pages: CaseIterable {
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

final class OptimizeBatteryChargingViewController: UIViewController {
    private let rootView = OptimizeBatteryChargingView()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
    }
}

extension OptimizeBatteryChargingViewController: ViewControllerProtocol {
    func setupUI() {
        
    }
    
    func addGestureRecognizers() {
        rootView.arrowBack.addTapGestureRecognizer { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
