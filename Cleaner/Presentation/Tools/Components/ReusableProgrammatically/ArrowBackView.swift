//
//  ArrowBackView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.11.2024.
//

import UIKit

var arrowBackButton: UIView = {
    let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
    
    let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = .arrowBackIcon
    imageView.center = view.center
    imageView.frame = view.bounds
    imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    
    view.addSubview(imageView)
    return view
}()
