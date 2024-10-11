//
//  UIFont+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 09.10.2024.
//

import UIKit

extension UIFont {
    
    static var regular11: UIFont? = UIFont(type: .regular, size: 11)
    
    static var medium12: UIFont? = UIFont(type: .medium, size: 12)
    
    static var bold15: UIFont? = UIFont(type: .bold, size: 15)
    
    enum MyFont {
        case regular, medium, bold
        
        var name: String {
            switch self {
            case .regular: "Poppins-Regular"
            case .medium: "Poppins-Medium"
            case .bold: "Poppins-Bold"
            }
        }
    }
    
    convenience init(type: MyFont, size: CGFloat) {
        self.init(name: type.name, size: size)!
    }
}
