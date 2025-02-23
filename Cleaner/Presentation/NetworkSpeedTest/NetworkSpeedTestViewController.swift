//
//  NetworkSpeedTestViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 24.01.2025.
//

import UIKit

final class NetworkSpeedTestViewController: UIViewController {
    private lazy var rootView = NetworkSpeedTestView()
    
    private lazy var networkService = NetworkService.shared
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func startTest() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        networkService.measureDownloadSpeed { [weak self] res in
            if res != nil && self?.rootView.mode != .restart {
                self?.rootView.updateData(type: .download, value: res!)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        networkService.measurePing { [weak self] res in
            if res != nil && self?.rootView.mode != .restart {
                self?.rootView.updateData(type: .ping, value: res!)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            if self?.rootView.mode != .restart {
                self?.rootView.bind(.restart)
            }
        }
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
            startTest()
        case .stop:
            rootView.bind(.restart)
        case .restart:
            rootView.bind(.stop)
            startTest()
        }
    }
}
