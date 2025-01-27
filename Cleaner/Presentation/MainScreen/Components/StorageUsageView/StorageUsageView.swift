//
//  StorageUsageView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.10.2024.
//

import UIKit

final class StorageUsageView: UIView {
    private lazy var nibName = "StorageUsageView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var storageUsageLabel: Semibold15LabelStyle!
    @IBOutlet weak var circularProgressBarView: StorageUsageProgressBar!
    @IBOutlet weak var freeStorageMemoryLabel: Semibold24LabelStyle!
    @IBOutlet weak var analyzeStorageButton: Medium12ButtonStyle!
    @IBOutlet weak var usedMemoryLabel: Regular13LabelStyle!
    
    private var totalSize: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func updateData() {
        if let totalSize, let freeSize = FileManager.default.getFreeStorageSizeInGigabytes() {
            let busySize = calcBusySize(freeSize: freeSize)
            let busySizeInPercent = calcBusySizePercentage(busySize: busySize)
            usedMemoryLabel.bind(text: "\(busySize) GB / \(totalSize) GB used")
            freeStorageMemoryLabel.bind(text: "\(busySizeInPercent) %")
            circularProgressBarView.progressAnimation(Double(busySizeInPercent) / 100)
        }
    }
    
    private func calcBusySize(freeSize: Int) -> Int {
        totalSize! - freeSize
    }
    
    private func calcBusySizePercentage(busySize: Int) -> Int {
        (busySize * 100) / totalSize!
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(nibName, owner: self)
        contentView.backgroundColor = .paleGrey
        contentView.layer.cornerRadius = 24
        contentView.clipsToBounds = true
        addShadows()
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        storageUsageLabel.text = "Storage Usage"
        freeStorageMemoryLabel.font = .bold24
        analyzeStorageButton.bind(text: "Analyze Storage")
        
        totalSize = FileManager.default.getTotalStorageSizeInGigabytes()
    }
}
