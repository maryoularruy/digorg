//
//  UIButtonStyles.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.10.2024.
//

import UIKit

class UIButtonMainScreenStyle: UIButton {
    private lazy var myConfiguration: Configuration = {
        var configuration = UIButton.Configuration.filled()
        configuration.titleAlignment = .center
        configuration.title = " "
        configuration.baseForegroundColor = .whiteText
        configuration.image = UIImage(resource: .arrowForwardWhite)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = -5
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 12, bottom: 3, trailing: 4)
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
    
    func bind(text: String) {
        setTitle(text, for: .normal)
        setTitle(text, for: .selected)
    }
    
    func bind(duplicatesCount: Int) {
        myConfiguration.title = "\(duplicatesCount) files / ? MB "
        configuration = myConfiguration
    }
    
    private func setup() {
        backgroundColor = .blueButtonBackground
        layer.cornerRadius = 20
        configuration = myConfiguration
    }
}

final class UIButtonActionToolbarStyle: UIButton {
    private lazy var myConfiguration: Configuration = {
        var configuration = UIButton.Configuration.filled()
        configuration.titleAlignment = .center
        configuration.title = " "
        configuration.baseBackgroundColor = .blueButtonBackground
        configuration.baseForegroundColor = .whiteText
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 3, bottom: 1, trailing: 3)
        configuration.cornerStyle = .capsule
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.bold15
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

final class UIButtonSecondaryStyle: UIButton {
    private lazy var myConfiguration: Configuration = {
        var configuration = UIButton.Configuration.filled()
        configuration.titleAlignment = .center
        configuration.title = " "
        configuration.baseBackgroundColor = .whiteBackground
        configuration.baseForegroundColor = .blueButtonBackground
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 3, bottom: 1, trailing: 3)
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
    
    func bind(text: String) {
        setTitle(text, for: .normal)
        setTitle(text, for: .selected)
    }
    
    func setTransparentBackground() {
        myConfiguration.baseBackgroundColor = .clear
        configuration = myConfiguration
    }
    
    private func setup() {
        layer.cornerRadius = 20
        configuration = myConfiguration
        addShadows()
    }
}
