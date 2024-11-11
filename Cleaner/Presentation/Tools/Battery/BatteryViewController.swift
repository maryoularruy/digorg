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
    @IBOutlet weak var batterySaveInstructionsStackView: UIStackView!
    
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
        
        BatteryInstructionCellType.allCases.forEach { type in
            let view = BatteryInstructionCell()
            view.delegate = self
            view.bind(type)
            batterySaveInstructionsStackView.addArrangedSubview(view)
        }
    }
    
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension BatteryViewController: BatteryInstructionCellDelegate {
    func tapOnCell(_ type: BatteryInstructionCellType) {
        let vc: UIViewController = switch type {
        case .optimizeBatteryCharging: OptimizeBatteryChargingViewController()
        case .lowPowerMode:
            OptimizeBatteryChargingViewController()
        case .managingConnections:
            OptimizeBatteryChargingViewController()
        case .locationServices:
            OptimizeBatteryChargingViewController()
        case .batteryUsage:
            OptimizeBatteryChargingViewController()
        case .backgroundRefresh:
            OptimizeBatteryChargingViewController()
        case .brightness:
            OptimizeBatteryChargingViewController()
        case .wifiResresh:
            OptimizeBatteryChargingViewController()
        case .limitNotifications:
            OptimizeBatteryChargingViewController()
        case .overheating:
            OptimizeBatteryChargingViewController()
        }
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        navigationController?.present(vc, animated: true)
    }
}
