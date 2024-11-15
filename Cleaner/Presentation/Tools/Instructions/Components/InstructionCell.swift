//
//  InstructionCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 15.11.2024.
//

import UIKit

protocol InstructionCellDelegate: AnyObject {
    func tapOnCell(_ type: InstructionCellType)
}

final class InstructionCell: UIView {
    private lazy var nibName = "InstructionCell"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: Semibold15LabelStyle!
    
    weak var delegate: InstructionCellDelegate?
    private var type: InstructionCellType?
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func bind(_ type: InstructionCellType) {
        self.type = type
        icon.image = type.icon
        title.bind(text: type.text)
    }

    private func setup() {
        Bundle.main.loadNibNamed(nibName, owner: self)
        contentView.layer.cornerRadius = 20
        addShadows()
        addSubview(contentView)
        contentView.frame = bounds
        
        addTapGestureRecognizer { [weak self] in
            guard let self, let type else { return }
            delegate?.tapOnCell(type)
        }
    }
}
