//
//  ItemCellHeader.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.10.2024.
//

import UIKit

protocol HeaderSelectAllButtonDelegate: AnyObject {
    func tapOnSelectAllButton(_ section: Int)
}

final class ItemCellHeader: UIView {
    private let nibName = "ItemCellHeader"
    
    weak var delegate: HeaderSelectAllButtonDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var firstLabel: Regular15LabelStyle!
    @IBOutlet weak var secondLabel: Regular15LabelStyle!
    @IBOutlet weak var selectAllButton: SelectionTransparentButtonStyle!
    
    private var section: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func bind(section: Int) {
        self.section = section
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(nibName, owner: self)
        secondLabel.setGreyTextColor()
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        selectAllButton.addTapGestureRecognizer { [weak self] in
            guard let self, let section else { return }
            delegate?.tapOnSelectAllButton(section)
        }
    }
}
