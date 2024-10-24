//
//  SelectionButtonStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.10.2024.
//

import UIKit

enum SelectionButtonText: String {
    case select = "Select"
    case selectAll = "Select All"
    case deselect = "Deselect"
    case deselectAll = "Deselect All"
}

class SelectionButtonStyle: UIButton {
    lazy var myConfiguration: Configuration = {
        var configuration = UIButton.Configuration.filled()
        configuration.titleAlignment = .center
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .blue
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        configuration.cornerStyle = .capsule
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.medium12
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
    
    func bind(text: SelectionButtonText) {
        myConfiguration.title = text.rawValue
        configuration = myConfiguration
    }
    
    func setup() {
        configuration = myConfiguration
        addShadow()
    }
}
