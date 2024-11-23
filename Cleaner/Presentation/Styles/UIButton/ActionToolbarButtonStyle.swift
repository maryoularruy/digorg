//
//  ActionToolbarButtonStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.10.2024.
//

import UIKit

final class ActionToolbarButtonStyle: UIButton {
    lazy var isClickable: Bool = true {
        didSet {
            isUserInteractionEnabled = isClickable
            backgroundColor = isClickable ? .blue : .paleBlue
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
        titleLabel?.text = text
    }
    
    func bind(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
    
    func bind(text: String, backgroundColor: UIColor = .blue, textColor: UIColor = .paleGrey, image: UIImage) {
        titleLabel?.text = text
        self.backgroundColor = backgroundColor
        titleLabel?.textColor = textColor
        imageView?.image = image
//        myConfiguration.imagePlacement = .leading
//        myConfiguration.imagePadding = 6
    }
    
    func setupCancelSubscriptionStyle() {
        titleLabel?.text = "Cancel Subscription"
        backgroundColor = .pureWhite
        titleLabel?.textColor = .darkGrey
    }
    
    private func setup() {
        layer.cornerRadius = 34
        titleLabel?.textAlignment = .center
        backgroundColor = .blue
        titleLabel?.textColor = .paleGrey
        titleLabel?.font = .semibold15
        
        
        
//            configuration.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 3, bottom: 1, trailing: 3)
//            configuration.cornerStyle = .capsule
    }
}
