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
        setupLayer(&backgroundLayer, isBackgroundLayer: true)
        setupLayer(&progressLayer, isBackgroundLayer: false)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer(&backgroundLayer, isBackgroundLayer: true)
        setupLayer(&progressLayer, isBackgroundLayer: false)
    }
    
    func progressAnimation(_ endValue: Double) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = 1.5
        circularProgressAnimation.toValue = endValue
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    
    private func createCircularPath() -> UIBezierPath {
        UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 110, startAngle: startPoint, endAngle: endPoint, clockwise: true)
    }
    
    private func setupLayer(_ layer: inout CAShapeLayer, isBackgroundLayer: Bool) {
        layer.path = createCircularPath().cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.lineWidth = 28.0
        layer.strokeEnd = isBackgroundLayer ? 1.0 : 0
        layer.strokeColor = isBackgroundLayer ? UIColor.lightGrey.cgColor : UIColor.blue.cgColor
        self.layer.addSublayer(layer)
    }
}
