//
//  CustomSegmentedControlButton.swift
//  Cleaner
//
//  Created by Elena Sedunova on 19.03.2025.
//

import UIKit

final class CustomSegmentedControlButton: UIButton {
    let index: Int
    let title: String
    
    var isSelectedButton: Bool {
        didSet {
            backgroundColor = isSelectedButton ? .blue : .paleGrey
            setTitleColor(isSelectedButton ? .paleGrey : .middleGrey, for: .normal)
        }
    }
    
    init(index: Int, title: String, isSelected: Bool) {
        self.index = index
        self.title = title
        self.isSelectedButton = isSelected
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStartSelectedIndex() {
        isSelectedButton = index == 0
    }
}
