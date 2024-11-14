//
//  OverheatingViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 14.11.2024.
//

import UIKit

final class OverheatingViewController: UIViewController {
    private lazy var rootView = OverheatingView()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
    }
}

extension OverheatingViewController: ViewControllerProtocol {
    func setupUI() {}
    
    func addGestureRecognizers() {
        rootView.arrowBack.addTapGestureRecognizer { [weak self] in
            self?.dismiss(animated: true)
        }
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }
    
    @objc private func handleSwipeRight() {
        dismiss(animated: true)
    }
}

