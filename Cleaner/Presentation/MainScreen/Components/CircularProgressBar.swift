//
//  CircularProgressBar.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.10.2024.
//

import UIKit

final class CircularProgressBar: UIView {
    private lazy var circleLayer = CAShapeLayer()
    private lazy var progressLayer = CAShapeLayer()
    private lazy var startPoint = CGFloat(Double.pi / 2)
    private lazy var endPoint = CGFloat(5 * Double.pi / 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircularPath()
    }
    
    private func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 45, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        circleLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 6.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.yellow.cgColor
        layer.addSublayer(progressLayer)
    }
    
    func progressAnimation(_ endValue: Double) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = 1.5
        circularProgressAnimation.toValue = endValue
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
