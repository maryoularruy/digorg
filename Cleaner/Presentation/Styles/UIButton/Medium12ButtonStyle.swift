//
//  Medium12ButtonStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.10.2024.
//

import UIKit

final class Medium12ButtonStyle: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func bind(text: String) {
        setTitle(text, for: .normal)
        setTitle(text, for: .selected)
    }
    
    func bind(duplicatesCount: Int) {
        titleLabel?.text = "\(duplicatesCount) files / ? MB "
    }
    
    private func setup() {
        backgroundColor = .blue
        layer.cornerRadius = 20
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = .white
        imageView?.image = .arrowForwardWhite
        titleLabel?.font = .medium12
//        configuration.imagePlacement = .trailing
//        configuration.imagePadding = -5
//        configuration.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 12, bottom: 3, trailing: 4)
    }
}
