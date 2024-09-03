//
//  PhoneInfoViewController.swift
//  Cleaner
//
//  Created by Максим Лебедев on 07.10.2023.
//

import UIKit

class PhoneInfoViewController: UIViewController {

    @IBOutlet weak var busyCPULabel: UILabel!
    @IBOutlet weak var maxRAM: UILabel!
    @IBOutlet weak var currentRAM: UILabel!
    @IBOutlet weak var downloadSpeedLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    var timer: Timer?
    var speedTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupUI()
    }
    
    private func setupActions() {
        backView.addTapGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupUI() {
        downloadSpeedLabel.text = PhoneInfoService.shared.downloadSpeed
        maxRAM.text = PhoneInfoService.shared.totalRAM
        updateData()
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        speedTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateSpeed), userInfo: nil, repeats: true)
    }
    
    @objc func updateData() {
        busyCPULabel.text = PhoneInfoService.shared.busyCPU
        currentRAM.text = PhoneInfoService.shared.freeRAM
    }
    
    @objc func updateSpeed() {
        downloadSpeedLabel.text = PhoneInfoService.shared.downloadSpeed
    }
}
