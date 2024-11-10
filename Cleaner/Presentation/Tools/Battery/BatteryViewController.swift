//
//  BatteryViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.11.2024.
//

import UIKit

final class BatteryViewController: UIViewController {
    @IBOutlet weak var arrowBackView: UIView!
    @IBOutlet weak var batteryLevelView: BatteryLevelView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.isBatteryMonitoringEnabled = true
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func batteryLevelDidChange() {
        batteryLevelView.bind(batteryLevel: UIDevice.current.batteryLevel, isPowerSavingMode: ProcessInfo.processInfo.isLowPowerModeEnabled)
    }
}

extension BatteryViewController: ViewControllerProtocol {
    func setupUI() {
        batteryLevelView.bind(batteryLevel: UIDevice.current.batteryLevel, isPowerSavingMode: ProcessInfo.processInfo.isLowPowerModeEnabled)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
    }
    
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
