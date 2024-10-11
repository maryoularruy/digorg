//
//  UIButtonStyles.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.10.2024.
//

import UIKit

final class UIButtonMainScreenStyle: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .blueButtonBackground
        layer.cornerRadius = 20
        
        var configuration = UIButton.Configuration.filled()
        configuration.titleAlignment = .center
        configuration.title = " "
        configuration.baseForegroundColor = .whiteText
        configuration.image = UIImage(resource: .arrowForwardWhite)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = -5
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 3, bottom: 10, trailing: 3)
        configuration.cornerStyle = .capsule
        self.configuration = configuration
    }
}
