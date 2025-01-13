//
//  DeviceInfoViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.01.2025.
//

import UIKit

final class DeviceInfoViewController: UIViewController {
    private lazy var rootView = DeviceInfoView()
    
//    @IBOutlet weak var busyCPULabel: UILabel!
//    @IBOutlet weak var maxRAM: UILabel!
//    @IBOutlet weak var currentRAM: UILabel!
//    @IBOutlet weak var downloadSpeedLabel: UILabel!
//    @IBOutlet weak var backView: UIView!
    
    var timer: Timer?
    var speedTimer: Timer?
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupActions()
//        setupUI()
    }
    
//    private func setupActions() {
//        backView.addTapGestureRecognizer {
//            self.navigationController?.popViewController(animated: true)
//        }
//    }
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
//    @objc func updateData() {
//        busyCPULabel.text = PhoneInfoService.shared.busyCPU
//        currentRAM.text = PhoneInfoService.shared.freeRAM
//    }
//    
//    @objc func updateSpeed() {
//        downloadSpeedLabel.text = PhoneInfoService.shared.downloadSpeed
//    }
}
