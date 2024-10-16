//
//  MediaService.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 19.05.2022.
//

import Photos
import Vision

protocol MediaServiceProtocol {
    func loadSimilarPhotos(from dateFrom: String, to dateTo: String, live: Bool, handler: @escaping ([PHAssetGroup], Int) -> ())
    func loadSimilarVideos(from dateFrom: String, to dateTo: String, handler: @escaping ([PHAssetGroup], Int) -> ())
}

final class MediaService: MediaServiceProtocol {
    static let shared = MediaService()
    static var defaultStartDate = "01 Jan 1970 00:00:00"
    static var defaultEndDate = "01 Jan 2030 00:00:00"
    
	private var maxAcceptableDifferenceBetweenDates = 10
    
    func loadSimilarPhotos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, live: Bool, handler: @escaping ([PHAssetGroup], Int) -> ()) {
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
                    DispatchQueue.main.async {
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
                        handler(similarPhotoGroups, duplicatesCount)
                    }
                }
            }
        }


	func loadSimilarVideos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, handler: @escaping ([PHAssetGroup], Int) -> ()) {
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
					DispatchQueue.main.async {
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
                        handler(similarVideoGroups, duplicatesCount)
					}
				}
			}
		}
    
    private func fetchPhotos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, live: Bool, handler: @escaping (PHFetchResult<PHAsset>) -> ()) {
           let options = PHFetchOptions()
           let albumsPhoto: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: live ? .smartAlbumLivePhotos : .smartAlbumUserLibrary, options: options)
           options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//        handler(PHAsset.fetchAssets(in: PHAssetCollection(), options: options))
           albumsPhoto.enumerateObjects { collection, index, object in
               handler(PHAsset.fetchAssets(in: collection, options: options))
           }
       }
    
    private func fetchVideos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, _ handler: @escaping ((PHFetchResult<PHAsset>) -> ())) {
          let options = PHFetchOptions()
          let albumVideos: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumVideos, options: options)
          options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
          albumVideos.enumerateObjects{ collection, index, object in
              handler(PHAsset.fetchAssets(in: collection, options: options))
          }
      }
}

extension MediaService {
    func loadSelfiePhotos(_ handler: @escaping (([PHAsset]) -> ())) {
        fetchSelfies({
            photoInAlbum in
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
        })
    }
    
    private func fetchSelfies(_ handler: @escaping ((PHFetchResult<PHAsset>) -> ())) {
        let options = PHFetchOptions()
        let albumsPhoto: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumSelfPortraits, options: options)
        options.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        albumsPhoto.enumerateObjects({(collection, index, object) in
            handler(PHAsset.fetchAssets(in: collection, options: options))
        })
    }
    
    private func fetchGIFs(_ handler: @escaping ((PHFetchResult<PHAsset>) -> ())) {
        let options = PHFetchOptions()
        let albumsPhoto: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumAnimated, options: options)
        options.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        albumsPhoto.enumerateObjects({(collection, index, object) in
            handler(PHAsset.fetchAssets(in: collection, options: options))
        })
    }
    
    func loadGifPhotos(_ handler: @escaping ([PHAsset]) -> ()) {
        fetchGIFs({
            photoInAlbum in
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
        })
    }
    
    func loadLivePhotos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate,_ handler: @escaping ([PHAsset]) -> ()) {
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

    func loadVideos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, _ handler: @escaping ([PHAsset]) -> ()) {
        fetchVideos(from: dateFrom, to: dateTo) { videoInAlbum in
            DispatchQueue.global(qos: .background).async {
                var images: [PHAsset] = []
                if videoInAlbum.count == 0 {
                    DispatchQueue.main.async {
                        handler([])
                    }
                    return
                }
                for i in 1...videoInAlbum.count {
                    images.append(videoInAlbum[i - 1])
                }
                DispatchQueue.main.async {
                    handler(images)
                }
            }
        }
    }
    
    func loadScreenshotPhotos(from dateFrom: String = defaultStartDate, to dateTo: String = defaultEndDate, _ handler: @escaping ([PHAsset]) -> ()) {
        self.fetchScreenshots(from: dateFrom, to: dateTo) { photoInAlbum in
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
    
    func fetchScreenshots(
        from dateFrom: String = "01-01-1970",
        to dateTo: String = "01-01-2030",
        handler: @escaping (PHFetchResult<PHAsset>) -> Void
    ) {
        let options = PHFetchOptions()
        let albumsPhoto: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .smartAlbumScreenshots,
            options: options
        )
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        handler(PHAsset.fetchAssets(in: albumsPhoto[0], options: options))
    }
}
