//
//  DeviceInfoViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.01.2025.
//

import UIKit

final class DeviceInfoViewController: UIViewController {
    private lazy var rootView = DeviceInfoView()
    
    private var timer: Timer?
    private var speedTimer: Timer?
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateRamAndCpu()
        updateSpeed()
        setupUI()
        addGestureRecognizers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
        speedTimer?.invalidate()
        speedTimer = nil
    }

    @objc func updateRamAndCpu() {
        rootView.ramView.bind(value: DeviceInfoService.shared.freeRam)
        rootView.cpuView.bind(value: DeviceInfoService.shared.busyCpu)
    }
    
    @objc func updateSpeed() {
        guard let downloadSpeed = DeviceInfoService.shared.downloadInfo else { return }
        rootView.downloadView.bind(value: downloadSpeed.byteCount)
    }
}

extension DeviceInfoViewController: ViewControllerProtocol {
    func setupUI() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateRamAndCpu), userInfo: nil, repeats: true)
        speedTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSpeed), userInfo: nil, repeats: true)
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
