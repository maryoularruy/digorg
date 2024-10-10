//
//  DeviceInfoCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 09.10.2024.
//

import UIKit

protocol CustomComponentProtocol {
    func setupView()
    func initConstraints()
}

struct DeviceInfoCellModel {
    let title: Title.RawValue
    let value: String
}

enum Title: String {
    case available = "Available", download = "Download", used = "Used"
}

class DeviceInfoCell: UIView {
    
    private lazy var title: UILabel = UILabel.subheadline()
    private lazy var value: UILabel = UILabel.subtitle()
    
    func bind(model: DeviceInfoCellModel) {
        title.text = model.title
        value.text = model.value
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        initConstraints()
    }
}

extension DeviceInfoCell: CustomComponentProtocol {
    
    func setupView() {
        backgroundColor = .whiteBackground
        layer.cornerRadius = 10
        addShadows()
    }
    
    func initConstraints() {
        addSubview(title)
        addSubview(value)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            value.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            value.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
}
