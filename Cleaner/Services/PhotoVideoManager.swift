//
//  PhotoVideoManager.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 19.05.2022.
//

import PhotosUI
import Vision

final class PhotoVideoManager {
    static let shared = PhotoVideoManager()
    static var defaultStartDate = "01 Jan 1970 00:00:00"
    static var defaultEndDate = "01 Jan 2030 00:00:00"
    
    var selectedPhotosForSmartCleaning: [PHAsset] = []
    var selectedScreenshotsForSmartCleaning: [PHAsset] = []
    var selectedVideosForSmartCleaning: [PHAsset] = []
    
    private(set) var similarPhotos: [PHAssetGroup] = []
    private(set) var similarVideos: [PHAssetGroup] = []
    
    func checkStatus(handler: @escaping (PHAuthorizationStatus) -> ()) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
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
    
    func fetchSimilarPhotos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, live: Bool, handler: @escaping ([PHAssetGroup], Int, Int64) -> ()) {
        fetchPhotos(from: dateFrom, to: dateTo, live: live) { photoInAlbum in
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self else { return }
                var images: [OSTuple<NSString, NSData>] = []
                if photoInAlbum.count == 0 {
                    DispatchQueue.main.async {
                        handler([], 0, 0)
                    }
                    return
                }
                
                for i in 1...photoInAlbum.count {
                    if let image = photoInAlbum[i - 1].image,
                       let data = image.jpegData(compressionQuality: 0.8),
                       !photoInAlbum[i - 1].mediaSubtypes.contains(.photoScreenshot) {
                        let tuple = OSTuple<NSString, NSData>(first: "image\(i)" as NSString, andSecond: data as NSData)
                        images.append(tuple)
                    }
                }
                
                let similarImageIdsAsTuples = OSImageHashing.sharedInstance().similarImages(with: OSImageHashingQuality.high, forImages: images)
                var similarPhotosNumbers: [Int] = []
                var similarPhotoGroups: [PHAssetGroup] = []
                guard similarImageIdsAsTuples.count >= 1 else {
                    DispatchQueue.main.async {
                        handler([], 0, 0)
                    }
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
                var size: Int64 = 0
                similarPhotoGroups.forEach { size += $0.assets.reduce(0) { $0 + $1.imageSize } }
                similarPhotos = similarPhotoGroups
                DispatchQueue.main.async {
                    handler(similarPhotoGroups, duplicatesCount, size)
                }
            }
        }
    }

    func fetchSimilarVideos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, handler: @escaping ([PHAssetGroup], Int, Int64) -> ()) {
        fetchVideos(from: dateFrom, to: dateTo) { videosInAlbum in
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self else { return }
                var videos: [OSTuple<NSString, NSData>] = []
                if videosInAlbum.count == 0 {
                    DispatchQueue.main.async {
                        handler([], 0, 0)
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
                var similarVideoNumbers: [Int] = []
                var similarVideoGroups: [PHAssetGroup] = []
                guard similarVideoIdsAsTuples.count >= 1 else {
                    DispatchQueue.main.async {
                        handler([], 0, 0)
                    }
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
                var size: Int64 = 0
                similarVideoGroups.forEach { size += $0.assets.reduce(0) { $0 + $1.imageSize } }
                similarVideos = similarVideoGroups
                DispatchQueue.main.async {
                    handler(similarVideoGroups, duplicatesCount, size)
                }
            }
        }
    }
    
    func fetchSuperSizedVideos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, handler: @escaping ([PHAsset]) -> ()) {
        fetchVideos(from: dateFrom, to: dateTo) { videos in
            DispatchQueue.global(qos: .userInitiated).async {
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
               DispatchQueue.global(qos: .userInitiated).async {
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
            DispatchQueue.global(qos: .userInitiated).async {
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
            DispatchQueue.global(qos: .userInitiated).async {
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
                DispatchQueue.main.async {
                    handler(blurryPhotos)
                }
            }
        }
    }
    
    func fetchScreenshots(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, _ handler: @escaping ([PHAsset]) -> ()) {
        fetchScreenshots { photoInAlbum in
            DispatchQueue.global(qos: .userInitiated).async {
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
    
    func chooseTheBest(_ assets: [PHAsset]) -> Int? {
        if assets.isEmpty {
            return nil
        }
        
        var indexOfBest = 0
        var sizeOfBest = assets[0].imageSize
        
        for i in 1..<assets.count {
            if sizeOfBest < assets[i].imageSize {
                indexOfBest = i
                sizeOfBest = assets[i].imageSize
            }
        }
        return indexOfBest
    }
    
    func join(_ groups: [PHAssetGroup]) -> [PHAsset] {
        var assets: [PHAsset] = []
        groups.forEach { assets.append(contentsOf: $0.assets) }
        return assets
    }
    
    func saveToCameraRollFolder(_ items: [SecretItemModel]) {
        items.forEach { item in
            switch item.mediaType {
            case .photo:
                guard let image = item.image else { break }
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                
            case .video:
                guard let path = item.videoUrl?.relativePath else { break }
                UISaveVideoAtPathToSavedPhotosAlbum(path, nil, nil, nil)
            }
        }
    }
    
    func delete(identifiers: [String]) {
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        var assets = [PHAsset]()
        fetchResult.enumerateObjects { asset, _, _  in
            assets.append(asset)
        }
        PhotoVideoManager.shared.delete(assets: assets)
    }
    
    func delete(assets: [PHAsset]) -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var result = false
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(assets as NSArray)}, completionHandler: { success, _ in
                if success {
                    result = true
                }
            semaphore.signal()
        })
        let semaphoreResult = semaphore.wait(timeout: .distantFuture)
        return semaphoreResult == .success ? result : false
    }
    
    func sort(_ assetGroups: inout [PHAssetGroup], type: SortType) {
        switch type {
        case .latest:
            assetGroups.sort { $0.assets[0].creationDate ?? Date(timeIntervalSince1970: 0) > $1.assets[0].creationDate ?? Date(timeIntervalSince1970: 0) }
        case .oldest:
            assetGroups.sort { $0.assets[0].creationDate ?? Date(timeIntervalSince1970: 0) < $1.assets[0].creationDate ?? Date(timeIntervalSince1970: 0) }
        case .largest:
            assetGroups.sort { $0.assets.reduce(0) { $0 + $1.imageSize } > $1.assets.reduce(0) { $0 + $1.imageSize } }
        case .date:
            break
        }
    }
    
    func sort(_ assets: inout [PHAsset], type: SortType) {
        switch type {
        case .latest:
            assets.sort { $0.creationDate ?? Date(timeIntervalSince1970: 0) > $1.creationDate ?? Date(timeIntervalSince1970: 0) }
        case .oldest:
            assets.sort { $0.creationDate ?? Date(timeIntervalSince1970: 0) < $1.creationDate ?? Date(timeIntervalSince1970: 0) }
        case .largest:
            assets.sort { $0.imageSize > $1.imageSize }
        case .date:
            break
        }
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
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            handler(status)
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
