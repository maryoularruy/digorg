//
//  DismissButtonStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 21.10.2024.
//

import UIKit

final class DismissButtonStyle: UIButton {
    private lazy var myConfiguration: Configuration = {
        var configuration = UIButton.Configuration.filled()
        configuration.titleAlignment = .center
        configuration.baseBackgroundColor = .white
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
        myConfiguration.title = text
        configuration = myConfiguration
    }
    
    private func setup() {
        configuration = myConfiguration
    }
}
