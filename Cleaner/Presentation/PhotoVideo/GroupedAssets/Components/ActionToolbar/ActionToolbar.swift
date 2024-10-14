//
//  ActionToolbar.swift
//  Cleaner
//
//  Created by Elena Sedunova on 14.10.2024.
//

import UIKit

final class ActionToolbar: UIView {
    private lazy var nibName = "ActionToolbar"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var toolbarButton: UIButtonActionToolbarStyle!
    
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
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addSubview(contentView)
        contentView.frame = bounds
        
        toolbarButton.bind(text: "Delete 33 items, 120 MB")
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
