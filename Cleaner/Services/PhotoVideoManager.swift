//
//  PhotoVideoManager.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 19.05.2022.
//

import Photos
import Vision

protocol PhotoVideoManagerProtocol {
    func fetchSimilarPhotos(from dateFrom: String, to dateTo: String, live: Bool, handler: @escaping ([PHAssetGroup], Int) -> ())
    func fetchSimilarVideos(from dateFrom: String, to dateTo: String, handler: @escaping ([PHAssetGroup], Int) -> ())
}

final class PhotoVideoManager: PhotoVideoManagerProtocol {
    static let shared = PhotoVideoManager()
    static var defaultStartDate = "01 Jan 1970 00:00:00"
    static var defaultEndDate = "01 Jan 2030 00:00:00"
    
    private(set) var isLoadingPhotos: Bool = false
    private(set) var isLoadingVideos: Bool = false
    
    private(set) var similarPhotos: [PHAssetGroup] = []
    private(set) var similarPhotosCount: Int = 0
    
    func checkStatus(handler: @escaping (PHAuthorizationStatus) -> ()) {
        let status = if #available(iOS 14, *) {
            PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            PHPhotoLibrary.authorizationStatus()
        }
        
        if status == .notDetermined {
            requestPhotoLibraryAutorization() { status in
                handler(status)
            }
        } else {
            handler(status)
        }
    }
    
    func fetchAllPhotos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, handler: @escaping ([PHAsset]) -> ()) {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: options)
        var photos: [PHAsset] = []
        fetchResult.enumerateObjects { asset, _, _ in
            photos.append(asset)
        }
        handler(photos)
    }
    
    func fetchAllVideos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, handler: @escaping ([PHAsset]) -> ()) {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: options)
        var videos: [PHAsset] = []
        fetchResult.enumerateObjects { asset, _, _ in
            videos.append(asset)
        }
        handler(videos)
    }
    
    func fetchSimilarPhotos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, live: Bool, handler: @escaping ([PHAssetGroup], Int) -> ()) {
        isLoadingPhotos = true
        fetchPhotos(from: dateFrom, to: dateTo, live: live) { photoInAlbum in
            DispatchQueue.global(qos: .userInitiated).async {
                    var images: [OSTuple<NSString, NSData>] = []
                    if photoInAlbum.count == 0 {
                        DispatchQueue.main.async {
                            handler([], 0)
                        }
                        return
                    }
                    
                    for i in 1...photoInAlbum.count {
                        if let image = photoInAlbum[i - 1].image, let data = image.jpegData(compressionQuality: 0.8) {
                            let tuple = OSTuple<NSString, NSData>(first: "image\(i)" as NSString,
                                                                  andSecond: data as NSData)
                            images.append(tuple)
                        }
                    }
                    
                    let similarImageIdsAsTuples = OSImageHashing.sharedInstance().similarImages(with: OSImageHashingQuality.high, forImages: images)
                    DispatchQueue.main.async { [weak self] in
                        var similarPhotosNumbers: [Int] = []
                        var similarPhotoGroups: [PHAssetGroup] = []
                        guard similarImageIdsAsTuples.count >= 1 else {
                            handler([], 0)
                            return
                        }
                        for i in 1...similarImageIdsAsTuples.count {
                            let tuple = similarImageIdsAsTuples[i - 1]
                            var groupAssets: [PHAsset] = []
                            let n = (tuple.first! as String).removeImageAndToInt() - 1
                            let n2 = (tuple.second! as String).removeImageAndToInt() - 1
                            if abs(n2 - n) >= 10 { continue }
                            if !similarPhotosNumbers.contains(n){
                                similarPhotosNumbers.append(n)
                                groupAssets.append(photoInAlbum[n])
                            }
                            if !similarPhotosNumbers.contains(n2) {
                                similarPhotosNumbers.append(n2)
                                groupAssets.append(photoInAlbum[n2])
                            }
                            similarImageIdsAsTuples.filter({$0.first != nil && $0.second != nil}).filter({ $0.first == tuple.first || $0.first == tuple.second || $0.second == tuple.second || $0.second == tuple.first }).forEach({ tuple in
                                let n = (tuple.first! as String).removeImageAndToInt() - 1
                                let n2 = (tuple.second! as String).removeImageAndToInt() - 1
                                if abs(n2 - n) >= 10{
                                    return
                                }
                                if !similarPhotosNumbers.contains(n) {
                                    similarPhotosNumbers.append(n)
                                    groupAssets.append(photoInAlbum[n])
                                }
                                if !similarPhotosNumbers.contains(n2) {
                                    similarPhotosNumbers.append(n2)
                                    groupAssets.append(photoInAlbum[n2])
                                }
                            })
                            if groupAssets.count >= 2 {
                                similarPhotoGroups.append(PHAssetGroup(name: "", assets: groupAssets, subtype: .smartAlbumUserLibrary))
                            }
                        }
                        for index in similarPhotoGroups.indices {
                            similarPhotoGroups[index].assets = similarPhotoGroups[index].assets.filter { !$0.isVideo }
                        }
                        similarPhotoGroups.removeAll { group in group.assets.isEmpty }
                        let duplicatesCount = similarPhotoGroups.reduce(0) { $0 + $1.assets.count }
                        self?.similarPhotos = similarPhotoGroups
                        self?.isLoadingPhotos = false
                        self?.similarPhotosCount = duplicatesCount
                        handler(similarPhotoGroups, duplicatesCount)
                    }
                }
            }
        }


	func fetchSimilarVideos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, handler: @escaping ([PHAssetGroup], Int) -> ()) {
        isLoadingVideos = true
			fetchVideos(from: dateFrom, to: dateTo) { videosInAlbum in
				DispatchQueue.global(qos: .background).async {
					var videos: [OSTuple<NSString, NSData>] = []
					if videosInAlbum.count == 0 {
						DispatchQueue.main.async{
                            handler([], 0)
						}
						return
					}
                    
					for i in 1...videosInAlbum.count {
						if let videoThumbnail = videosInAlbum[i - 1].image, let data = videoThumbnail.jpegData(compressionQuality: 0.8) {
							let tuple = OSTuple<NSString, NSData>(first: "video\(i)" as NSString,
																  andSecond: data as NSData)
							videos.append(tuple)
						}
					}
                    
					let similarVideoIdsAsTuples = OSImageHashing.sharedInstance().similarImages(withProvider: .pHash, forImages: videos)
					DispatchQueue.main.async { [weak self] in
						var similarVideoNumbers: [Int] = []
						var similarVideoGroups: [PHAssetGroup] = []
                        guard similarVideoIdsAsTuples.count >= 1 else {
                            handler([], 0)
                            return
                        }
						for i in 1...similarVideoIdsAsTuples.count {
							let tuple = similarVideoIdsAsTuples[i - 1]
							var groupAssets: [PHAsset] = []
							let n = (tuple.first! as String).removeVideoAndToInt() - 1
							let n2 = (tuple.second! as String).removeVideoAndToInt() - 1
							if abs(n2 - n) >= 10 { continue }
							if !similarVideoNumbers.contains(n) {
								similarVideoNumbers.append(n)
								groupAssets.append(videosInAlbum[n])
							}
							if !similarVideoNumbers.contains(n2) {
								similarVideoNumbers.append(n2)
								groupAssets.append(videosInAlbum[n2])
							}
							similarVideoIdsAsTuples.filter{$0.first != nil && $0.second != nil}.filter({ $0.first == tuple.first || $0.first == tuple.second || $0.second == tuple.second || $0.second == tuple.first }).forEach { tuple in
								let n = (tuple.first! as String).removeVideoAndToInt() - 1
								let n2 = (tuple.second! as String).removeVideoAndToInt() - 1
								if abs(n2 - n) >= 10 {
									return
								}
								if !similarVideoNumbers.contains(n) {
									similarVideoNumbers.append(n)
									groupAssets.append(videosInAlbum[n])
								}
								if !similarVideoNumbers.contains(n2) {
									similarVideoNumbers.append(n2)
									groupAssets.append(videosInAlbum[n2])
								}
							}
							if groupAssets.count >= 1 {
                                similarVideoGroups.append(PHAssetGroup(name: "", assets: groupAssets, subtype: .smartAlbumVideos))
							}
						}
                        for index in similarVideoGroups.indices {
                            similarVideoGroups[index].assets = similarVideoGroups[index].assets.filter { $0.isVideo }
                        }
                        similarVideoGroups.removeAll { group in group.assets.isEmpty }
                        let duplicatesCount = similarVideoGroups.reduce(0) { $0 + $1.assets.count }
                        self?.isLoadingVideos = false
                        handler(similarVideoGroups, duplicatesCount)
					}
				}
			}
		}
    
    func fetchSuperSizedVideos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, handler: @escaping ([PHAsset]) -> ()) {
        fetchVideos(from: dateFrom, to: dateTo) { videos in
            DispatchQueue.global(qos: .background).async {
                var superSizedVideos: [PHAsset] = []
                if videos.count == 0 {
                    DispatchQueue.main.async {
                        handler([])
                    }
                    return
                }
                
                let superSized = 500000000
                for i in 1...videos.count {
                    if videos[i - 1].imageSize >= superSized {
                        superSizedVideos.append(videos[i - 1])
                    }
                }
                
                DispatchQueue.main.async {
                    handler(superSizedVideos)
                }
            }
        }
    }
    
    func fetchLivePhotos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, _ handler: @escaping ([PHAsset]) -> ()) {
           fetchPhotos(from: dateFrom, to: dateTo, live: true) { photoInAlbum in
               DispatchQueue.global(qos: .background).async {
                   var images: [PHAsset] = []
                   if photoInAlbum.count == 0 {
                       DispatchQueue.main.async {
                           handler([])
                       }
                       return
                   }
                   for i in 1...photoInAlbum.count{
                       images.append(photoInAlbum[i - 1])
                   }
                   DispatchQueue.main.async {
                       handler(images)
                   }
               }
           }
       }
    
    func fetchSelfiePhotos(_ handler: @escaping (([PHAsset]) -> ())) {
        fetchSelfies { photoInAlbum in
            DispatchQueue.global(qos: .background).async {
                var images: [PHAsset] = []
                if photoInAlbum.count == 0 {
                    DispatchQueue.main.async {
                        handler([])
                    }
                    return
                }
                for i in 1...photoInAlbum.count {
                    images.append(photoInAlbum[i - 1])
                }
                DispatchQueue.main.async {
                    handler(images)
                }
            }
        }
    }
    
    func fetchBlurryPhotos(_ handler: @escaping (([PHAsset]) -> ())) {
        fetchAllPhotos { assets in
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = true
            
            var blurryPhotos: [PHAsset] = []
            
            assets.forEach { asset in
                PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: options) { image, _ in
                    guard let image = image, let cgImage = image.cgImage else { return }
                    
                    _ = VNGenerateImageFeaturePrintRequest { request, error in
                        guard error == nil else { return }
                        
                        if request.results is [VNFeaturePrintObservation] {
                            if self.calculateSharpness(cgImage: cgImage) < 100 {
                                blurryPhotos.append(asset)
                            }
                        }
                    }
                }
            }
            handler(blurryPhotos)
        }
    }
    
    func join(_ groups: [PHAssetGroup]) -> [PHAsset] {
        var assets: [PHAsset] = []
        groups.forEach { assets.append(contentsOf: $0.assets) }
        return assets
    }
    
    private func fetchPhotos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, live: Bool, handler: @escaping (PHFetchResult<PHAsset>) -> ()) {
           let options = PHFetchOptions()
           let albumsPhoto: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: live ? .smartAlbumLivePhotos : .smartAlbumUserLibrary, options: options)
           options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
           albumsPhoto.enumerateObjects { collection, _, _ in
               handler(PHAsset.fetchAssets(in: collection, options: options))
           }
       }
    
    private func fetchVideos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, _ handler: @escaping ((PHFetchResult<PHAsset>) -> ())) {
          let options = PHFetchOptions()
          let albumVideos: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumVideos, options: options)
          options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
          albumVideos.enumerateObjects { collection, _, _ in
              handler(PHAsset.fetchAssets(in: collection, options: options))
          }
      }
    
    private func fetchSelfies(_ handler: @escaping ((PHFetchResult<PHAsset>) -> ())) {
        let options = PHFetchOptions()
        let albumsPhoto: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumSelfPortraits, options: options)
        options.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        albumsPhoto.enumerateObjects { collection, _, _ in
            handler(PHAsset.fetchAssets(in: collection, options: options))
        }
    }
    
    private func requestPhotoLibraryAutorization(handler: @escaping (PHAuthorizationStatus) -> ()) {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                handler(status)
            }
            
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                handler(status)
            }
        }
    }
}

extension PhotoVideoManager {
    private func calculateSharpness(cgImage: CGImage) -> Float {
        let ciImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: "CILaplacian")!
        let width = 8
        let height = 8
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        let context = CIContext()
        guard let outputImage = filter.outputImage,
              let _ = context.createCGImage(outputImage, from: outputImage.extent) else { return 0 }
        
        let pixelData = [UInt8](repeating: 0, count: width * height)
        return calculateVariance(of: pixelData)
    }
    
    private func calculateVariance(of pixelData: [UInt8]) -> Float {
        let mean = Float(pixelData.reduce(0, +)) / Float(pixelData.count)
        let variance = Float(pixelData.reduce(0) { $0 + Int(pow(Float($1) - mean, 2)) }) / Float(pixelData.count)
        return variance
    }

    func loadScreenshotPhotos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, _ handler: @escaping ([PHAsset]) -> ()) {
        fetchScreenshots { photoInAlbum in
            DispatchQueue.global(qos: .background).async{
                var images: [PHAsset] = []
                if photoInAlbum.count == 0 {
                    DispatchQueue.main.async {
                        handler([])
                    }
                    return
                }
                for i in 1...photoInAlbum.count {
                    images.append(photoInAlbum[i - 1])
                }
                DispatchQueue.main.async {
                    handler(images)
                }
            }
        }
    }
    
    func getAssetsWithText(completion: @escaping ([PHAsset]) -> Void) {
        fetchPhotos(live: false) { fetchResult in }
    }
    
    private func fetchScreenshots(handler: @escaping (PHFetchResult<PHAsset>) -> Void) {
        let options = PHFetchOptions()
        let albumsPhoto: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .smartAlbumScreenshots,
            options: options
        )
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        handler(PHAsset.fetchAssets(in: albumsPhoto[0], options: options))
    }
}
