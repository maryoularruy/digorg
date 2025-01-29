//
//  SettingsOptionCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 29.01.2025.
//

import UIKit

protocol SettingsOptionCellDelegate: AnyObject {
    func tapOnCell(option: SettingsOption)
}

final class SettingsOptionCell: UIView {
    weak var delegate: SettingsOptionCellDelegate?
    static var height: CGFloat = 52.0
    
    private lazy var title: Semibold15LabelStyle = Semibold15LabelStyle()
    private lazy var rightArrowImageView: UIImageView = UIImageView(image: .arrowForwardGrey)
    
    private lazy var optionSwitch: UISwitch = {
        let optionSwitch = UISwitch()
        optionSwitch.onTintColor = .blue
        return optionSwitch
    }()
    
    private var option: SettingsOption
    
    init(option: SettingsOption) {
        self.option = option
        super.init(frame: .zero)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        title.bind(text: option.title)
        
        if let isSwitchable = option.isSwitchable {
            optionSwitch.isOn = isSwitchable
            optionSwitch.addTarget(self, action: #selector(switchStateDidChange(_:)), for: .valueChanged)
        } else {
            addTapGestureRecognizer { [weak self] in
                guard let self else { return }
                delegate?.tapOnCell(option: option)
            }
        }
    }
    
    @objc func switchStateDidChange(_ sender: UISwitch!) {
        option.isSwitchable = sender.isOn
        delegate?.tapOnCell(option: option)
    }
    
    private func initConstraints() {
        addSubviews([title])
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        if let _ = option.isSwitchable {
            addSubviews([optionSwitch])
            
            NSLayoutConstraint.activate([
                optionSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                optionSwitch.centerYAnchor.constraint(equalTo: title.centerYAnchor),
                optionSwitch.heightAnchor.constraint(equalToConstant: 31)
            ])
        } else {
            addSubviews([rightArrowImageView])
            
            NSLayoutConstraint.activate([
                rightArrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                rightArrowImageView.centerYAnchor.constraint(equalTo: title.centerYAnchor),
                rightArrowImageView.heightAnchor.constraint(equalToConstant: 20),
                rightArrowImageView.widthAnchor.constraint(equalToConstant: 20)
            ])
        }
    }
}
