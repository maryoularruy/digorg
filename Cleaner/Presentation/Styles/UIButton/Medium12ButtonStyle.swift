//
//  Medium12ButtonStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.10.2024.
//

import UIKit

final class Medium12ButtonStyle: UIButton {
    private lazy var myConfiguration: Configuration = {
        var configuration = UIButton.Configuration.filled()
        configuration.titleAlignment = .center
        configuration.title = " "
        configuration.baseForegroundColor = .white
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
        backgroundColor = .blue
        layer.cornerRadius = 20
        configuration = myConfiguration
    }
}
