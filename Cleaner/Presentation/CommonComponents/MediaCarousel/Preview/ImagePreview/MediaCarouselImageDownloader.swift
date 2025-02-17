//
//  MediaCarouselImageDownloader.swift
//
//  Created by ZhangAo on 2018/6/6.
//

import Photos
import SDWebImage

protocol MediaCarouselImageDownloader {
    
    static func downloader() -> MediaCarouselImageDownloader
    
    func downloadImage(with identifier: Any, progressBlock: ((_ progress: Float) -> Void)?,
                       completeBlock: @escaping ((_ image: UIImage?, _ data: Data?,  _ error: Error?) -> Void))
    
}

class MediaCarouselImageWebDownloader: MediaCarouselImageDownloader {
    
    private static let shared = MediaCarouselImageWebDownloader()
    
    static func downloader() -> MediaCarouselImageDownloader {
        return shared
    }
    
    var _downloader: SDWebImageDownloader = {
        let config = SDWebImageDownloaderConfig()
        config.executionOrder = .lifoExecutionOrder
        let downloader = SDWebImageDownloader.init(config: config)
        
        return downloader
    }()
    
    func downloadImage(with identifier: Any, progressBlock: ((Float) -> Void)?,
                       completeBlock: @escaping ((UIImage?, Data?, Error?) -> Void)) {
        if let URL = identifier as? URL {
            self._downloader.downloadImage(with: URL,
                                           options: .highPriority,
                                           progress: { (receivedSize, expectedSize, targetURL) in
                                            if let progressBlock = progressBlock {
                                                progressBlock(Float(receivedSize) / Float(expectedSize))
                                            }
            }, completed: { (image, data, error, finished) in
                if (image != nil || data != nil) && finished {
                    completeBlock(image, data, error)
                } else {
                    let error = NSError(domain: Bundle.main.bundleIdentifier!, code: -1, userInfo: [
                        NSLocalizedDescriptionKey : MediaCarouselResource.localizedStringWithKey("preview.image.fetch.error")
                        ])
                    completeBlock(nil, nil, error)
                }
            })
        } else {
            assertionFailure()
        }
    }
    
}

class MediaCarouselImageAssetDownloader: MediaCarouselImageDownloader {
    
    private static let shared = MediaCarouselImageAssetDownloader()
    
    static func downloader() -> MediaCarouselImageDownloader {
        return shared
    }
    
    func downloadImage(with identifier: Any, progressBlock: ((Float) -> Void)?,
                       completeBlock: @escaping ((UIImage?, Data?, Error?) -> Void)) {
        if let asset = identifier as? PHAsset {
            let options = PHImageRequestOptions()
            options.resizeMode = .exact
            options.deliveryMode = .highQualityFormat
            options.isNetworkAccessAllowed = true
            if let progressBlock = progressBlock {
                options.progressHandler = { (progress, error, stop, info) in
                    if progress > 0 {
                        progressBlock(Float(progress))
                    }
                }
            }
            
            PHImageManager.default().requestImage(for: asset,
                                                  targetSize: CGSize(width: UIScreen.main.bounds.width * UIScreen.main.scale, height:UIScreen.main.bounds.height * UIScreen.main.scale),
                                                  contentMode: .default,
                                                  options: options,
                                                  resultHandler: { (image, info) in
                if let image = image {
                    completeBlock(image, nil, nil)
                } else {
                    let error = NSError(domain: Bundle.main.bundleIdentifier!, code: -1, userInfo: [
                        NSLocalizedDescriptionKey : MediaCarouselResource.localizedStringWithKey("preview.image.fetch.error")
                    ])
                    completeBlock(nil, nil, error)
                }
            })
        }
    }
}
