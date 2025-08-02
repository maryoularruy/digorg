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
    }
    
    func bind(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
    
    func bind(text: String, backgroundColor: UIColor = .blue, textColor: UIColor = .paleGrey, image: UIImage? = nil, borderColor: UIColor = .clear, borderWidth: CGFloat = 0.0) {
        self.backgroundColor = backgroundColor
        
        setTitle(text, for: .normal)
        setTitleColor(textColor, for: .normal)
        
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        
        imageView?.image = image
    }
    
    func setupCancelSubscriptionStyle() {
        backgroundColor = .pureWhite
        
        setTitle("Cancel Subscription", for: .normal)
        setTitleColor(.darkGrey, for: .normal)
    }
    
    func animate() {
        UIView.animate(withDuration: 0.6, delay: 0.2, options: [.allowUserInteraction], animations: {
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { _ in
            UIView.animate(withDuration: 0.4, delay: 0.1, options: [.allowUserInteraction], animations: {
                self.transform = .identity
            })
        }
    }
    
    private func setup() {
        backgroundColor = .blue
        layer.cornerRadius = frame.height / 2
        contentEdgeInsets = UIEdgeInsets(top: 1, left: 3, bottom: 1, right: 3)
       
        setTitleColor(.paleGrey, for: .normal)
        titleLabel?.font = .semibold15
        titleLabel?.textAlignment = .center
    }
}
