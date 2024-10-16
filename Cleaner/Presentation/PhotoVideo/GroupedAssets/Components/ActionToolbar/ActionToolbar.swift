//
//  ActionToolbar.swift
//  Cleaner
//
//  Created by Elena Sedunova on 14.10.2024.
//

import UIKit

protocol ActionToolbarDelegate {
    func removeItems()
}

final class ActionToolbar: UIView {
    private lazy var nibName = "ActionToolbar"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var toolbarButton: UIButtonActionToolbarStyle!
    var delegate: ActionToolbarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    @IBAction func tapOnToolbarButton(_ sender: Any) {
        delegate?.removeItems()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(nibName, owner: self)
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
