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
        setTitle(text, for: .normal)
        setTitle(text, for: .selected)
    }
    
    func bind(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
    
    func bind(text: String, backgroundColor: UIColor = .blue, textColor: UIColor = .paleGrey, image: UIImage) {
        self.backgroundColor = backgroundColor
        
        setTitle(text, for: .normal)
        setTitle(text, for: .selected)
        setTitleColor(textColor, for: .normal)
        setTitleColor(textColor, for: .selected)
        
        imageView?.image = image
//        myConfiguration.imagePlacement = .leading
//        myConfiguration.imagePadding = 6
    }
    
    func setupCancelSubscriptionStyle() {
        backgroundColor = .pureWhite
        
        setTitle("Cancel Subscription", for: .normal)
        setTitle("Cancel Subscription", for: .selected)
        setTitleColor(.darkGrey, for: .normal)
        setTitleColor(.darkGrey, for: .selected)
    }
    
    private func setup() {
        backgroundColor = .blue
        layer.cornerRadius = frame.height / 2
        contentEdgeInsets = UIEdgeInsets(top: 1, left: 3, bottom: 1, right: 3)
       
        setTitleColor(.paleGrey, for: .normal)
        setTitleColor(.paleGrey, for: .selected)
        titleLabel?.font = .semibold15
        titleLabel?.textAlignment = .center
    }
}
