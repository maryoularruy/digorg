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
    @IBOutlet weak var titleLabel: Semibold15LabelStyle!
    @IBOutlet weak var infoButton: Medium12ButtonStyle!
    @IBOutlet weak var imageView: UIImageView!
    
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
        imageView.setImage(UIImage(resource: option.image))
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(nibName, owner: self)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 24
        contentView.clipsToBounds = true
        addShadows()
        addSubview(contentView)
        contentView.frame = bounds
    }
}
