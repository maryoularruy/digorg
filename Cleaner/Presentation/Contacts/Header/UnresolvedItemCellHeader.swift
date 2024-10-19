//
//  UnresolvedItemCellHeader.swift
//  Cleaner
//
//  Created by Elena Sedunova on 18.10.2024.
//

import UIKit

final class UnresolvedItemCellHeader: UIView {
    private let nibName = "UnresolvedItemCellHeader"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var unresolvedItemsInSection: Regular15LabelStyle!
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
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
