//
//  LowPowerModeViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 13.11.2024.
//

import UIKit

final class LowPowerModeViewController: UIViewController {
    private lazy var rootView = LowPowerModeView()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
    }
}

extension LowPowerModeViewController: ViewControllerProtocol {
    func setupUI() {}
    
    func addGestureRecognizers() {
        rootView.arrowBack.addTapGestureRecognizer { [weak self] in
            self?.dismiss(animated: true)
        }
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }
    
    @objc override func handleSwipeRight() {
        dismiss(animated: true)
    }
}
