//
//  ToolOptionView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 30.10.2024.
//

import UIKit

protocol ToolOptionViewDelegate: AnyObject {
    func tapOnOption(_ option: ToolOption)
}

final class ToolOptionView: UIView {
    private lazy var nibName = "ToolOptionView"
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: Semibold15LabelStyle!
    @IBOutlet weak var optionDescription: Regular13LabelStyle!
    @IBOutlet weak var premiumImageView: UIImageView!
    
    weak var delegate: ToolOptionViewDelegate?
    private(set) var type: ToolOption?
    
    init(_ type: ToolOption) {
        self.type = type
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setLocked() {
        isUserInteractionEnabled = false
        premiumImageView.isHidden = false
    }
    
    func unlock() {
        isUserInteractionEnabled = true
        premiumImageView.isHidden = true
    }
    
    private func bind() {
        guard let type else { return }
        icon.image = type.icon
        title.bind(text: type.rawValue)
        optionDescription.bind(text: type.description)
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(nibName, owner: self)
        contentView.layer.cornerRadius = 20
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addShadows()
        
        contentView.addTapGestureRecognizer { [weak self] in
            guard let self, let type else { return }
            delegate?.tapOnOption(type)
        }
        
        bind()
    }
}
