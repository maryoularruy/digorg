//
//  CleanupOptionView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.10.2024.
//

import UIKit

final class CleanupOptionView: UIView {
    private lazy var nibName = "CleanupOptionView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabelSubtitleStyle!
    @IBOutlet weak var infoButton: UIButtonMainScreenStyle!
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func bind(_ option: CleanupOption) {
        titleLabel.text = option.rawValue
        titleLabel.attributedText = NSAttributedString(string: option.rawValue, attributes: titleLabel.attributes)
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(nibName, owner: self)
        layer.cornerRadius = 24
        addShadows()
        addSubview(contentView)
        contentView.frame = bounds
    }
}
