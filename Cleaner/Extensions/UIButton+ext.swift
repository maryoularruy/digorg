//
//  UIButton+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 20.10.2024.
//

import UIKit

extension UIButton {
    func addShadow() {
        let shadowLayer = CAShapeLayer()
        layer.cornerRadius = 20
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.fillColor = backgroundColor?.cgColor
        shadowLayer.shadowColor = UIColor.shadowColor.cgColor
        shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        shadowLayer.shadowOpacity = 0.72
        shadowLayer.shadowRadius = 4.0
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func setupShadow() {
        layer.shadowColor = UIColor.shadowColor.cgColor
        layer.shadowOpacity = 0.72
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowRadius = 4.0
    }
}
