//
//  CustomSegmentedControl.swift
//  Cleaner
//
//  Created by Elena Sedunova on 19.03.2025.
//

import UIKit

protocol CustomSegmentedControlDelegate: AnyObject {
    func tapOnButton(index: Int)
}

final class CustomSegmentedControl: UIStackView {
    weak var delegate: CustomSegmentedControlDelegate?
    
    var selectedIndex: Int {
        buttons.firstIndex { $0.isSelectedButton == true } ?? 0
    }
    
    private let buttons: [CustomSegmentedControlButton]
    
    init(buttons: [CustomSegmentedControlButton]) {
        self.buttons = buttons
        super.init(frame: .zero)
        setupView()
        bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        buttons.forEach { button in
            button.layer.cornerRadius = 12.0
            button.layer.cornerCurve = .circular
            
            button.setTitle(button.title, for: .normal)
            button.titleLabel?.font = .medium12
            
            button.setStartSelectedIndex()
            button.tag = button.index
            
            button.addTarget(self, action: #selector(tapOnButton), for: .touchUpInside)
            
            addArrangedSubview(button)
        }
    }
    
    @objc func tapOnButton(button: UIButton) {
        delegate?.tapOnButton(index: button.tag)
        updateUI(selectedIndex: button.tag)
    }
    
    private func updateUI(selectedIndex: Int) {
        buttons.forEach { $0.isSelectedButton = $0.index == selectedIndex }
    }
    
    private func setupView() {
        distribution = .fillEqually
        axis = .horizontal
        spacing = 0
        
        layer.cornerRadius = 12
        addShadows()
    }
}
