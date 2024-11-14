//
//  ManagingConnectionsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 14.11.2024.
//

import UIKit

final class ManagingConnectionsViewContoller: UIViewController {
    private lazy var rootView = ManagingConnectionsView()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
    }
}

extension ManagingConnectionsViewContoller: ViewControllerProtocol {
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
