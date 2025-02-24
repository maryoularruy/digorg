//
//  UIImageView+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 24.02.2025.
//

import UIKit

private let _currentImageKey = malloc(4)

extension UIImageView {
//    var currentImage: UIImage? {
//        get { return possiblyNil(_currentImageKey) }
//        set { objc_setAssociatedObject(self, _currentImageKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
//    }
//    
//    private func possiblyNil<T>(_ key:UnsafeMutableRawPointer?) -> T? {
//        let result = objc_getAssociatedObject(self, key!)
//        
//        if result == nil {
//            return nil
//        }
//        
//        return (result as? T)
//    }
}

extension String {
    fileprivate func pathExtension() -> String {
        return (self as NSString).pathExtension
    }
}
