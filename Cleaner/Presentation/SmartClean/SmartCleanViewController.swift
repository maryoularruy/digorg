//
//  SmartCleanViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 04.02.2025.
//

import UIKit

final class SmartCleanViewController: UIViewController {
    private lazy var rootView = SmartCleanView()
    
    override func loadView() {
        super.loadView()
        view = rootView
        
        //
        rootView.backgroundColor = .acidGreen
        //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
    }
}

extension SmartCleanViewController: ViewControllerProtocol {
    func setupUI() {
        
    }
    
    func addGestureRecognizers() {
//        rootView.arrowBack.addTapGestureRecognizer { [weak self] in
//            self?.navigationController?.popViewController(animated: true)
//        }
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }
}
