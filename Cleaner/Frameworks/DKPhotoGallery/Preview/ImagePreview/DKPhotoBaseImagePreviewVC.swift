//
//  DKPhotoBaseImagePreviewVC.swift
//  DKPhotoGallery
//
//  Created by ZhangAo on 15/09/2017.
//  Copyright © 2017 ZhangAo. All rights reserved.
//

import UIKit
import Photos

open class DKPhotoBaseImagePreviewVC: DKPhotoBasePreviewVC {
    // MARK: - DKPhotoBasePreviewDataSource
    
    override public func createContentView() -> UIView {
        let contentView = DKPhotoImageView()
        return contentView
    }
        
    override public func updateContentView(with content: Any) {
        guard let contentView = self.contentView as? DKPhotoImageView else { return }
        
        if let data = content as? Data {
            let imageFormat = NSData.sd_imageFormat(forImageData: data)
            if imageFormat == .GIF, let gifImage = try? UIImage(gifData: data) {
                contentView.setGifImage(gifImage)
            } else {
                contentView.image = UIImage(data: data)
            }
        } else if let image = content as? UIImage {
            contentView.image = image
        } else {
            assertionFailure()
        }
    }
    
    public override func snapshotImage() -> UIImage? {
        if let contentView = self.contentView as? DKPhotoImageView {
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
        
        guard let contentView = self.contentView as? DKPhotoImageView else { return }
        
        contentView.image = DKPhotoGalleryResource.downloadFailedImage()
        contentView.contentMode = .center
    }
    
    public override func hidesError() {
        contentView.contentMode = .scaleAspectFit
    }
    
    override public func contentSize() -> CGSize {
        guard let contentView = self.contentView as? DKPhotoImageView else { return CGSize.zero }
        
        if let image = contentView.image {
            return image.size
        } else if let animatedImage = contentView.currentImage {
            return animatedImage.size
        } else {
            return CGSize.zero
        }
    }
}
