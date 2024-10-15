//
//  DeviceInfoCell.swift
//  Cleaner
//
//  Created by Elena Sedunova on 09.10.2024.
//

import UIKit

enum Title: String, CaseIterable {
    case available = "Available", download = "Download", used = "Used"
    
    var index: Int {
        switch self {
        case .available: 0
        case .download: 1
        case .used: 2
        }
    }
}

final class DeviceInfoCell: UIView {
    private lazy var title: UILabel = UILabel.subheadline()
    private lazy var value: UILabel = UILabel.subtitle()
    
    init(cell: Title) {
        super.init(frame: .zero)
        title.text = cell.rawValue
        value.text = ""
        
        setupView()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        initConstraints()
    }
    
    func bind(newValue: String) {
        value.text = newValue
    }
    
    private func setupView() {
        backgroundColor = .whiteBackground
        layer.cornerRadius = 10
        addShadows()
    }
    
    private func initConstraints() {
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
