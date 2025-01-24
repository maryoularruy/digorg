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
        addGestureRecognizers()
    }
    
    //
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.speedTestView.bind()
    }
    //
    
    deinit {
        print("NetworkSpeedTestViewController deinit")
    }
}

extension NetworkSpeedTestViewController: ViewControllerProtocol {
    func setupUI() {
        
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
