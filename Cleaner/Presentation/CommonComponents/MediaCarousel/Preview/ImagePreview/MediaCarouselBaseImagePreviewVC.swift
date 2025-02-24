//
//  MediaCarouselBaseImagePreviewVC.swift
//
//  Created by ZhangAo on 15/09/2017.
//

import UIKit
import Photos

open class MediaCarouselBaseImagePreviewVC: MediaCarouselBasePreviewVC {
    // MARK: - MediaCarouselBasePreviewDataSource
    
    override public func createContentView() -> UIView {
        let contentView = MediaCarouselImageView()
        return contentView
    }
        
    override public func updateContentView(with content: Any) {
        guard let contentView = self.contentView as? MediaCarouselImageView else { return }
        
        if let data = content as? Data {
            contentView.image = UIImage(data: data)
        } else if let image = content as? UIImage {
            contentView.image = image
        } else {
            assertionFailure()
        }
    }
    
    public override func snapshotImage() -> UIImage? {
        if let contentView = self.contentView as? MediaCarouselImageView {
            if let image = contentView.image {
                return image
            } else {
                return self.item.thumbnail
            }
        } else {
            return self.item.thumbnail
        }
    }
    
    public override func showError() {
        if self.item.thumbnail != nil { return }
        
        guard let contentView = self.contentView as? MediaCarouselImageView else { return }
        
        contentView.image = MediaCarouselResource.downloadFailedImage()
        contentView.contentMode = .center
    }
    
    public override func hidesError() {
        contentView.contentMode = .scaleAspectFit
    }
    
    override public func contentSize() -> CGSize {
        guard let contentView = self.contentView as? MediaCarouselImageView else { return CGSize.zero }
        
        if let image = contentView.image {
            return image.size
        } else {
            return CGSize.zero
        }
    }
}
