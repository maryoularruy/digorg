//
//  ArrowBackView.swift
//  Cleaner
//
//  Created by Elena Sedunova on 11.11.2024.
//

import UIKit

var arrowBackButton: UIImageView {
    let view = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
    view.image = .arrowBackIcon
    view.contentMode = .center
    return view
}
