//
//  MediaCarouselImageView.swift
//  MediaCarousel
//
//  Created by ZhangAo on 13/12/2017.
//  Copyright © 2017 ZhangAo. All rights reserved.
//

import UIKit

open class MediaCarouselImageView: UIImageView {
    
    public override init(image: UIImage? = nil, highlightedImage: UIImage? = nil) {
        super.init(image: image, highlightedImage: highlightedImage)
        
        self.contentMode = .scaleAspectFit
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
