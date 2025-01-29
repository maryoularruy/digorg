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

final class SettingsOptionsContainer: UIView {
    weak var delegate: SettingsOptionsContainerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func bind(views: [SettingsOption]) {
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGrey
        
        views.forEach { option in
            let cell = SettingsOptionCell(option: option)
            cell.delegate = self
            addSubviews([cell])

            NSLayoutConstraint.activate([
                cell.leadingAnchor.constraint(equalTo: leadingAnchor),
                cell.trailingAnchor.constraint(equalTo: trailingAnchor),
                cell.heightAnchor.constraint(equalToConstant: SettingsOptionCell.height)
            ])
            
            if option == views.first {
                cell.topAnchor.constraint(equalTo: topAnchor).isActive = true
            } else {
                cell.topAnchor.constraint(equalTo: subviews[subviews.count - 2].bottomAnchor).isActive = true
            }
            
            if option == views.last {
                cell.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            } else {
                addSubviews([separatorView])
                
                NSLayoutConstraint.activate([
                    separatorView.topAnchor.constraint(equalTo: subviews[subviews.count - 2].bottomAnchor),
                    separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                    separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                    separatorView.heightAnchor.constraint(equalToConstant: 1)
                ])
            }
        }
    }
    
    private func setupView() {
        backgroundColor = .paleGrey
        layer.cornerRadius = 20
        addShadows()
    }
}

extension SettingsOptionsContainer: SettingsOptionCellDelegate {
    func tapOnCell(option: SettingsOption) {
        delegate?.tapOnOption(option)
    }
}
