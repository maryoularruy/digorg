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
        configuration.baseForegroundColor = .white
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 3, bottom: 1, trailing: 3)
        configuration.cornerStyle = .capsule
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.semibold15
            return outgoing
        }
        return configuration
    }()

    lazy var isClickable: Bool = true {
        didSet {
            isUserInteractionEnabled = isClickable
            myConfiguration.baseBackgroundColor = isClickable ? .blue : .paleBlueButtonBackground
            configuration = myConfiguration
        }
    }
    
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
    
    func bind(backgroundColor: UIColor) {
        myConfiguration.baseBackgroundColor = backgroundColor
        configuration = myConfiguration
    }
    
    func bind(text: String, backgroundColor: UIColor = .blue, textColor: UIColor = .white, image: UIImage) {
        myConfiguration.title = text
        myConfiguration.baseBackgroundColor = backgroundColor
        myConfiguration.baseForegroundColor = textColor
        myConfiguration.image = image
        myConfiguration.imagePlacement = .leading
        myConfiguration.imagePadding = 6
        configuration = myConfiguration
    }
    
    private func setup() {
        layer.cornerRadius = 34
        configuration = myConfiguration
    }
}
