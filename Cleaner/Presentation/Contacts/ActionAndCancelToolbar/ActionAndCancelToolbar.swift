//
//  ActionAndCancelToolbar.swift
//  Cleaner
//
//  Created by Elena Sedunova on 21.10.2024.
//

import UIKit

protocol ActionAndCancelToolbarProtocol: AnyObject {
    func tapOnAction()
    func tapOnCancel()
}

final class ActionAndCancelToolbar: UIView {
    private lazy var nibName = "ActionAndCancelToolbar"

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var actionButton: ActionToolbarButtonStyle!
    weak var delegate: ActionAndCancelToolbarProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    @IBAction func tapOnAction(_ sender: Any) {
        delegate?.tapOnAction()
    }
    
    @IBAction func tapOnCancel(_ sender: Any) {
        delegate?.tapOnCancel()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(nibName, owner: self)
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addShadows()
    }
}
