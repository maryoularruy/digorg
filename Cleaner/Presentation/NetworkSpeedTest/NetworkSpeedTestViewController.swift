//
//  NetworkSpeedTestViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 24.01.2025.
//

import UIKit

final class NetworkSpeedTestViewController: UIViewController {
    private lazy var rootView = NetworkSpeedTestView()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
    
    //
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        rootView.speedTestView.bind(value: 5.2436, type: .download)
    }
    //
    
    deinit {
        print("NetworkSpeedTestViewController deinit")
    }
}

extension NetworkSpeedTestViewController: ViewControllerProtocol {
    func setupUI() {
        rootView.toolbar.delegate = self
    }
    
    func addGestureRecognizers() {
        rootView.arrowBack.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }
}

extension NetworkSpeedTestViewController: ActionToolbarDelegate {
    func tapOnActionButton() {
        switch rootView.mode {
        case .start:
            rootView.bind(.stop)
        case .stop:
            rootView.bind(.restart)
        case .restart:
            rootView.bind(.stop)
        }
    }
}
