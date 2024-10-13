//
//  GradientService.swift
//  Cleaner
//
//  Created by Максим Лебедев on 08.10.2023.
//

import UIKit

class GradientService {
    
    static let shared  = GradientService()
    
    func addGradientBackgroundToButton(button: UIButton, colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds.insetBy(dx: -0.5*button.bounds.size.width, dy: -0.5*button.bounds.size.height)
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)

        button.layer.masksToBounds = true
        button.layer.insertSublayer(gradientLayer, at: 0)
        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = colors.map { $0.cgColor }
//        gradientLayer.locations = [0, 1]
//        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
//        gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -0.23, b: 1.08, c: -0.69, d: -0.96, tx: 1.03, ty: 0.36))
//        gradientLayer.bounds = button.bounds.insetBy(dx: -0.5*button.bounds.size.width, dy: -0.5*button.bounds.size.height)
//        gradientLayer.position = button.center
////        button.layer.addSublayer(gradientLayer)
//        button.layer.insertSublayer(gradientLayer, at: 0)
    }
}
