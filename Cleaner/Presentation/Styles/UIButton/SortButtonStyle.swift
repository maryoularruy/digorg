//
//  SortButtonStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 16.12.2024.
//

import UIKit

enum SortType {
    case latest, oldest, largest, date
    
    var title: String {
        switch self {
        case .latest:
            "Latest"
        case .oldest:
            "Oldest"
        case .largest:
            "Largest"
        case .date:
            "Select date"
        }
    }
}

final class SortButtonStyle: UIButton {
    private var type: SortType?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func bind(type: SortType) {
        self.type = type
        setTitle(type.title, for: .normal)
        setTitle(type.title, for: .selected)
    }
    
    private func setup() {
        isUserInteractionEnabled = true
        
        backgroundColor = .paleGrey
        layer.cornerRadius = 20
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 40, bottom: 8, right: 12)
        
        titleLabel?.textAlignment = .right
        setTitleColor(.blue, for: .normal)
        setTitleColor(.blue, for: .selected)
        titleLabel?.font = .medium12
        
        setImage(.sortIcon, for: .normal)
        setImage(.sortIcon, for: .selected)
        imageView?.contentMode = .scaleAspectFill
        tintColor = .blue
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        semanticContentAttribute = .forceLeftToRight
        
        bind(type: .latest)
    }
}
