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
        rootView.ramView.bind(value: PhoneInfoService.shared.freeRam)
        setupUI()
        addGestureRecognizers()
    }
//    
//    private func setupUI() {
//        downloadSpeedLabel.text = PhoneInfoService.shared.downloadSpeed
//        maxRAM.text = PhoneInfoService.shared.totalRAM
//        updateData()
//        
//        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
//        speedTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateSpeed), userInfo: nil, repeats: true)
//    }
//    
    @objc func updateRamAndCpu() {
        rootView.ramView.bind(value: PhoneInfoService.shared.freeRam)
//        busyCPULabel.text = PhoneInfoService.shared.busyCPU
//        currentRAM.text = PhoneInfoService.shared.freeRAM
    }
//    
//    @objc func updateSpeed() {
//        downloadSpeedLabel.text = PhoneInfoService.shared.downloadSpeed
//    }
}

extension DeviceInfoViewController: ViewControllerProtocol {
    func setupUI() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateRamAndCpu), userInfo: nil, repeats: true)
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
