//
//  SettingsOptionsContainer.swift
//  Cleaner
//
//  Created by Elena Sedunova on 29.01.2025.
//

import UIKit

protocol SettingsOptionsContainerDelegate: AnyObject {
    func tapOnOption(_ option: SettingsOption)
}

final class SettingsOptionsContainer: UIStackView {
    weak var delegate: SettingsOptionsContainerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func bind(options: [SettingsOption]) {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        options.forEach { option in
            let cell = SettingsOptionCell(option: option)
            cell.delegate = self
            
            addArrangedSubview(cell)
            
            if option != options.last {
                addArrangedSubview(getSeparator())
            }
        }
    }
    
    private func getSeparator() -> UIView {
        let view = UIView()
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGrey
        view.addSubviews([separatorView])
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: view.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        return view
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
        layer.cornerRadius = 20
        addShadows()
        
        axis = .vertical
    }
}

extension SettingsOptionsContainer: SettingsOptionCellDelegate {
    func tapOnCell(option: SettingsOption) {
        delegate?.tapOnOption(option)
    }
}
