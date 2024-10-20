//
//  ActionToolbarButtonStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.10.2024.
//

import UIKit

final class ActionToolbarButtonStyle: UIButton {
    private lazy var myConfiguration: Configuration = {
        var configuration = UIButton.Configuration.filled()
        configuration.titleAlignment = .center
        configuration.title = " "
        configuration.baseBackgroundColor = .blue
        configuration.baseForegroundColor = .whiteText
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 3, bottom: 1, trailing: 3)
        configuration.cornerStyle = .capsule
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
    
    func changeBackgroundColor(_ color: UIColor) {
        myConfiguration.baseBackgroundColor = color
        configuration = myConfiguration
    }
    
    private func setup() {
        layer.cornerRadius = 34
        configuration = myConfiguration
    }
}
