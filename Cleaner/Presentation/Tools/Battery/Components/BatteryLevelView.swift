//
//  BatteryLevelView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.11.2024.
//

import UIKit

final class BatteryLevelView: UIView {
    private lazy var nibName = "BatteryLevelView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var batteryLevelLabel: Semibold15LabelStyle!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var savingModeLabel: Regular15LabelStyle!
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func bind(batteryLevel: Int, isPowerSavingMode: Bool) {
        batteryLevelLabel.bind(text: "Battery level \(batteryLevel)%")
        progressBar.progress = batteryLevel.toProgressBarValue()
        savingModeLabel.bind(text: "Power saving mode: \(isPowerSavingMode ? "on" : "off")")
    }

    private func setup() {
        Bundle.main.loadNibNamed(nibName, owner: self)
        contentView.layer.cornerRadius = 20
        savingModeLabel.setGreyTextColor()
        addShadows()
        addSubview(contentView)
        contentView.frame = bounds
    }
}
