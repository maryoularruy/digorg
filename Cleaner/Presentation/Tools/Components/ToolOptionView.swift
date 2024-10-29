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
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: Semibold15LabelStyle!
    @IBOutlet weak var optionDescription: Regular13LabelStyle!
    @IBOutlet weak var proView: UIImageView!
    
    weak var delegate: ToolOptionViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func bind(_ option: ToolOption) {
        icon.image = option.icon
        title.bind(text: option.rawValue)
        optionDescription.bind(text: option.description)
        proView.isHidden = !option.isProFunction
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
