//
//  Medium12WithSpinnerButtonStyle.swift
//  Cleaner
//
//  Created by Elena Sedunova on 25.02.2025.
//

import UIKit

final class Medium12WithSpinnerButtonStyle: UIButton {
    private lazy var spinner = UIActivityIndicatorView(style: .medium)
    
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
        
        imageView?.contentMode = .scaleAspectFill
        setImage(.arrowForwardWhite, for: .normal)
        tintColor = .paleGrey
        imageEdgeInsets = if titleLabel == nil || titleLabel?.text == "" || titleLabel?.text == " " {
            UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        } else {
            UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 12)
        }
        semanticContentAttribute = .forceRightToLeft
    }
    
    func addSpinner() {
        spinner.color = .paleGrey
        spinner.isHidden = true
        
        addSubviews([spinner])
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func startSpinner() {
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    func endSpinner() {
        spinner.isHidden = true
        spinner.stopAnimating()
    }
    
    private func setup() {
        backgroundColor = .blue
        layer.cornerRadius = 20

        contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 0)
        
        titleLabel?.textAlignment = .center
        titleLabel?.textColor = .paleGrey
        titleLabel?.font = .medium12
        setTitle("       ", for: .normal)
        
        addSpinner()
    }
}
