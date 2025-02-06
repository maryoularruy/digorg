//
//  CircularLoader.swift
//  Cleaner
//
//  Created by Elena Sedunova on 06.02.2025.
//

import UIKit

final class CircularLoaderView: UIView {
    private lazy var circleLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircularPath()
    }
    
    func startAnimation() {
        isHidden = false
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1.0
        animation.duration = 1.0
        animation.repeatCount = .infinity
        animation.fillMode = .forwards
        circleLayer.add(animation, forKey: "circularAnimation")
    }
    
    func endAnimation() {
        isHidden = true
        circleLayer.removeAllAnimations()
    }
    
    private func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: bounds.width / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.strokeColor = UIColor.blue.withAlphaComponent(0.6).cgColor
        circleLayer.lineWidth = 4
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.strokeEnd = 0.1
        circleLayer.lineCap = .round
        layer.addSublayer(circleLayer)
    }
}

