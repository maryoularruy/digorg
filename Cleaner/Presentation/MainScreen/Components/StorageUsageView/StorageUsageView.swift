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
    @IBOutlet weak var storageUsageLabel: UILabelSubtitleStyle!
    @IBOutlet weak var circularProgressBarView: CircularProgressBarView!
    @IBOutlet weak var freeStorageMemoryLabel: UILabelSubtitleStyle!
    @IBOutlet weak var analyzeStorageButton: UIButtonMainScreenStyle!
    @IBOutlet weak var usedMemoryLabel: UILabelSubhealine13sizeStyle!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(nibName, owner: self)
        layer.cornerRadius = 24
        addShadows()
        addSubview(contentView)
        contentView.frame = bounds
        
        storageUsageLabel.text = "Storage Usage"
        
        freeStorageMemoryLabel.text = "55%"
        freeStorageMemoryLabel.font = .bold24
        
        analyzeStorageButton.bind(text: "Analyze Storage")
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
