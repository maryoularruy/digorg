//
//  MediaCarouselPreviewFactory.swift
//  MediaCarousel
//
//  Created by ZhangAo on 15/09/2017.
//  Copyright © 2017 ZhangAo. All rights reserved.
//

import Foundation
import Photos

@objc
extension MediaCarouselBasePreviewVC {
    
    @objc public class func photoPreviewClass(with item: MediaCarouselItem) -> MediaCarouselBasePreviewVC.Type {
        if item.image != nil {
            return MediaCarouselImagePreviewVC.self
            
        } else if item.imageURL != nil {
            return MediaCarouselImagePreviewVC.self
            
        } else if let asset = item.asset {
            if asset.mediaType == .video {
                return MediaCarouselPlayerPreviewVC.self
            } else {
                return MediaCarouselImagePreviewVC.self
            }
            
        } else if let assetLocalIdentifier = item.assetLocalIdentifier {
            item.asset = PHAsset.fetchAssets(withLocalIdentifiers: [assetLocalIdentifier], options: nil).firstObject
            item.assetLocalIdentifier = nil
            return self.photoPreviewClass(with: item)
            
        } else if item.videoURL != nil {
            return MediaCarouselPlayerPreviewVC.self

        } else {
            assertionFailure()
            return MediaCarouselBasePreviewVC.self
        }
    }
    
    @objc public class func photoPreviewVC(with item: MediaCarouselItem) -> MediaCarouselBasePreviewVC {
        let previewVC = self.photoPreviewClass(with: item).init()
        previewVC.item = item
        
        return previewVC
    }
}
