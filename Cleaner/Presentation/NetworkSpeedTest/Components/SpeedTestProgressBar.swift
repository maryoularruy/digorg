//
//  SpeedTestProgressBar.swift
//  Cleaner
//
//  Created by Elena Sedunova on 24.01.2025.
//

import UIKit

final class SpeedTestProgressBar: UIView {
    private lazy var backgroundLayer = CAShapeLayer()
    private lazy var progressLayer = CAShapeLayer()
    private lazy var startPoint = CGFloat(7 * Double.pi / 8)
    private lazy var endPoint = CGFloat(2 * Double.pi + Double.pi / 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackgroundLayer()
        setupProgressLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupProgressLayer()
    }
    
    func progressAnimation(_ endValue: Double) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = 1.5
        circularProgressAnimation.toValue = endValue
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    
    private func setupBackgroundLayer() {
        backgroundLayer.path = createCircularPath().cgPath
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineCap = .round
        backgroundLayer.lineWidth = 28.0
        backgroundLayer.strokeEnd = 1.0
        backgroundLayer.strokeColor = UIColor.lightGrey.cgColor
        layer.addSublayer(backgroundLayer)
    }
    
    private func setupProgressLayer() {
        progressLayer.path = createCircularPath().cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 28.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.blue.cgColor
        layer.addSublayer(progressLayer)
    }
    
    private func createCircularPath() -> UIBezierPath {
        UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 110, startAngle: startPoint, endAngle: endPoint, clockwise: true)
    }
}
