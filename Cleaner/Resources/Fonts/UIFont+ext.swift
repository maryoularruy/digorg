//
//  UIFont+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 09.10.2024.
//

import UIKit

extension UIFont {
    
    static var regular11: UIFont? = UIFont(.regular, size: 11)
    static var regular13: UIFont? = UIFont(.regular, size: 13)
    static var regular15: UIFont? = UIFont(.regular, size: 15)
    
    static var medium12: UIFont? = UIFont(.medium, size: 12)
    static var medium13: UIFont? = UIFont(.medium, size: 13)
    
    static var semibold15: UIFont? = UIFont(.semibold, size: 15)
    static var semibold24: UIFont? = UIFont(.semibold, size: 24)
    
    static var bold15: UIFont? = UIFont(.bold, size: 15)
    static var bold24: UIFont? = UIFont(.bold, size: 24)
    
    enum MyFont {
        case regular, medium, semibold, bold
        
        var name: String {
            switch self {
            case .regular: "Poppins-Regular"
            case .medium: "Poppins-Medium"
            case .semibold: "Poppins-SemiBold"
            case .bold: "Poppins-Bold"
            }
        }
    }
    
    convenience init(_ type: MyFont, size: CGFloat) {
        self.init(name: type.name, size: size)!
    }
}
