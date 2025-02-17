//
//  MediaCarouselItem.swift
//
//  Created by ZhangAo on 08/09/2017.
//

import UIKit
import Photos

public let MediaCarouselItemExtraInfoKeyRemoteImageOriginalURL: String = "MediaCarouselItemExtraInfoKeyRemoteImageOriginalURL"    // URL.
public let MediaCarouselItemExtraInfoKeyRemoteImageOriginalSize: String = "MediaCarouselItemExtraInfoKeyRemoteImageOriginalSize"  // (Optional)UInt. The number of bytes of the image.

@objc
public class MediaCarouselItemConstant: NSObject {
    
    @objc public class func extraInfoKeyRemoteImageOriginalURL() -> String {
        return MediaCarouselItemExtraInfoKeyRemoteImageOriginalURL
    }
    
    @objc public class func extraInfoKeyRemoteImageOriginalSize() -> String {
        return MediaCarouselItemExtraInfoKeyRemoteImageOriginalSize
    }
    
}

//////////////////////////////////////////////////////////////////

@objc
open class MediaCarouselItem: NSObject {
    
    /// The image to be set initially, until the image request finishes.
    @objc open var thumbnail: UIImage?
    
    @objc open var image: UIImage?
    @objc open var imageURL: URL?
    
    @objc open var videoURL: URL?

    /**
     MediaCarousel will automatically decide whether to create ImagePreview or PlayerPreview via the mediaType of the asset.
     
     See more: MediaCarouselPreviewFactory.swift
     */
    @objc open var asset: PHAsset?
    @objc open var assetLocalIdentifier: String?
    
    /**
     Used for some optional features.
     
     For ImagePreview, you can enable the original image download feature with a key named MediaCarouselItemExtraInfoKeyRemoteImageOriginalURL.
     */
    @objc open var extraInfo: [String: Any]?
    
    @objc convenience public init(image: UIImage) {
        self.init()
        
        self.image = image
    }
    
    @objc convenience public init(imageURL: URL) {
        self.init()
        
        self.imageURL = imageURL
    }
    
    @objc convenience public init(videoURL: URL) {
        self.init()
        
        self.videoURL = videoURL
    }

    @objc convenience public init(asset: PHAsset) {
        self.init()
        
        self.asset = asset
    }
    
    @objc public class func items(withImageURLs URLs: [URL]) -> [MediaCarouselItem] {
        var items: [MediaCarouselItem] = []
        for URL in URLs {
            let item = MediaCarouselItem()
            item.imageURL = URL
            
            items.append(item)
        }
        
        return items
    }
    
    @objc public class func items(withImageURLStrings URLStrings: [String]) -> [MediaCarouselItem] {
        var items: [MediaCarouselItem] = []
        for URLString in URLStrings {
            let item = MediaCarouselItem()
            item.imageURL = URL(string: URLString)
            
            items.append(item)
        }
        
        return items
    }
}
