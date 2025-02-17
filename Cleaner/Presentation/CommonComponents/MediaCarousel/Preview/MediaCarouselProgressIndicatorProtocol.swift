//
//  MediaCarouselProgressIndicatorProtocol.swift
//
//  Created by ZhangAo on 08/09/2017.
//

import Foundation
import UIKit

public protocol MediaCarouselProgressIndicatorProtocol: NSObjectProtocol {
    init(with view: UIView)
    func startIndicator()
    func stopIndicator()
    func setIndicatorProgress(_ progress: Float)
}

