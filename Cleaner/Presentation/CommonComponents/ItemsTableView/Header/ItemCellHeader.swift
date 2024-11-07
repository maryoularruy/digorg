//
//  ItemCellHeader.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.10.2024.
//

import UIKit

final class ItemCellHeader: UIView {
    private let nibName = "ItemCellHeader"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var firstLabel: Regular15LabelStyle!
    @IBOutlet weak var secondLabel: Regular15LabelStyle!
    @IBOutlet weak var selectAllButton: SelectionTransparentButtonStyle!
    
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
        secondLabel.setGreyTextColor()
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
