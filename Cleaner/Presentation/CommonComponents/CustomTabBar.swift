//
//  CustomTabBar.swift
//  Cleaner
//
//  Created by Elena Sedunova on 30.10.2024.
//

import UIKit

final class CustomTabBar: UITabBar {
    private static let size = CGSize(width: 253, height: 62)
    private static let bottomAnchor = 32.0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        layer.cornerRadius = 22
        clipsToBounds = true
        addShadowsWithoutClipToBounds()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        guard let superview else { return }
        let x = (superview.frame.width / 2) - (CustomTabBar.size.width / 2)
        let y = superview.frame.maxY - CustomTabBar.size.height - CustomTabBar.bottomAnchor
        frame = CGRect(origin: CGPoint(x: x, y: y), size: CustomTabBar.size)
    }
}
