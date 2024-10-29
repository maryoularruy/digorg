//
//  ToolOptionView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 30.10.2024.
//

import UIKit

protocol ToolOptionViewDelegate: AnyObject {
    func tapOnOption()
}

final class ToolOptionView: UIView {
    private lazy var nibName = "ToolOptionView"
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet var contentView: UIView!
    
    weak var delegate: ToolOptionViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func bind() {
        
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(nibName, owner: self)
        layer.cornerRadius = 20
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addShadows()
        
        contentView.addTapGestureRecognizer { [weak self] in
            self?.delegate?.tapOnOption()
        }
    }
}
