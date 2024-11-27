//
//  Extension+PHAsset.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 27.05.2022.
//

import Photos
import UIKit

enum TargetSize {
    case small, medium, large
    
    var size: CGSize {
        switch self {
        case .small:
            CGSize(width: 78, height: 78)
        case .medium:
            CGSize(width: 109, height: 109)
        case .large:
            CGSize(width: 133, height: 133)
        }
    }
}

extension PHAsset: Differentiable { }

extension PHAsset {
	/// To get Thumbnail image from PHAssets
	var image: UIImage? {
		let manager = PHImageManager.default()
		let option = PHImageRequestOptions()
		var thumbnail: UIImage?
		option.isSynchronous = true
		manager.requestImage(for: self, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
			thumbnail = result
		})
		return thumbnail
	}
	/// To get Thumbnail image from PHAssets
	var hdImage: UIImage? {
		get {
			let manager = PHImageManager.default()
			let option = PHImageRequestOptions()
			var thumbnail: UIImage?
			option.resizeMode = .fast
			option.deliveryMode = .opportunistic
			option.isNetworkAccessAllowed = true
			option.version = .current
			manager.requestImage(for: self, targetSize: CGSize(width: 600, height: 600), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
				
				thumbnail = result

			})
			return thumbnail
		}
	}
	
	/// To get size image on disk from PHAssets
	var imageSize : Int64 {
		let resources = PHAssetResource.assetResources(for: self)
		var sizeOnDisk: Int64 = 0

		if let resource = resources.first {
			let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
			sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
		}
		
		return sizeOnDisk
	}
	
	func getAssetThumbnail() -> UIImage {
		let manager = PHImageManager.default()
		let option = PHImageRequestOptions()
		
		var thumbnail = UIImage()
		option.isSynchronous = true
		
		option.isNetworkAccessAllowed = true
		option.deliveryMode = .opportunistic
		option.version = .current
		option.resizeMode = .exact
		manager.requestImage(
			for: self,
			targetSize: CGSize(width: self.pixelWidth / 3, height: self.pixelHeight / 3),
			contentMode: .aspectFit,
			options: option,
			resultHandler: {(result, info) -> Void in
				thumbnail = result ?? #imageLiteral(resourceName: "gif")
			})
		return thumbnail
	}
    
    func getAssetThumbnail(_ targetSize: TargetSize = TargetSize.medium) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        
        var thumbnail = UIImage()
        option.isSynchronous = true
        
        option.deliveryMode = .opportunistic
        option.version = .current
        option.resizeMode = .exact
        manager.requestImage(
            for: self,
            targetSize: targetSize.size,
            contentMode: .aspectFit,
            options: option,
            resultHandler: {(result, info) -> Void in
                thumbnail = result ?? #imageLiteral(resourceName: "gif")
            })
        return thumbnail
    }
	
	func getHighQualityImage() -> UIImage {
		let manager = PHImageManager.default()
		let option = PHImageRequestOptions()
		var thumbnail = UIImage()
		option.isSynchronous = true
		option.version = .original
		option.isNetworkAccessAllowed = true

		manager.requestImage(
			for: self,
			targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight),
			contentMode: .aspectFit,
			options: option,
			resultHandler: {(result, info) -> Void in
				thumbnail = result ?? #imageLiteral(resourceName: "selfies")
			})
		return thumbnail
	}
}
