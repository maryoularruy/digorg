//
//  CancelButtonStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 21.10.2024.
//

import UIKit

final class CancelButtonStyle: UIButton {
    private lazy var myConfiguration: Configuration = {
        var configuration = UIButton.Configuration.filled()
        configuration.titleAlignment = .center
        configuration.title = "Cancel"
        configuration.baseBackgroundColor = .whiteBackground
        configuration.baseForegroundColor = .blue
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 3, bottom: 1, trailing: 3)
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.semibold15
            return outgoing
        }
        return configuration
    }()
    
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
    
    private func setup() {
        configuration = myConfiguration
    }
}
