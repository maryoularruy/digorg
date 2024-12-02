//
//  SearchViewController.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 19.05.2022.
//

import UIKit
import Photos

final class SearchViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var searchLabel: UILabel!
    
    private let mediaService = PhotoVideoManager.shared
    private var cleanupOption: CleanupOption?
    
	private lazy var timer = Timer()
	private lazy var counter = 0
    
	override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true, block: { [weak self] _ in
            self?.updateSearch()
        })
        
        guard let cleanupOption else { return }
		switch cleanupOption.mode {
			case .duplicatePhotos:
				titleLabel.text = "Duplicate photos"
				mediaService.fetchSimilarPhotos(live: false) { assetGroups, duplicatesCount in
					let vc = StoryboardScene.GroupedAssets.initialScene.instantiate()
					vc.modalPresentationStyle = .fullScreen
					vc.assetGroups = assetGroups
                    vc.duplicatesCount = duplicatesCount
					DispatchQueue.main.async { [weak self] in
						self?.navigationController?.pushViewController(vc, animated: true)
						self?.timer.invalidate()
					}
				}
			case .live:
				titleLabel.text = "Live photos"
				mediaService.fetchLivePhotos { assets in
					let vc = StoryboardScene.RegularAssets.initialScene.instantiate()
					vc.modalPresentationStyle = .fullScreen
					vc.assets = assets
					vc.type = .live
					DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
						self.navigationController?.pushViewController(vc, animated: true)
						self.timer.invalidate()
					}
				}
			case .selfies:
				titleLabel.text = "Selfies"
				mediaService.fetchSelfiePhotos { assets in
					let vc = StoryboardScene.RegularAssets.initialScene.instantiate()
					vc.modalPresentationStyle = .fullScreen
					vc.assets = assets
					vc.type = .selfie
					DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
						self.navigationController?.pushViewController(vc, animated: true)
						self.timer.invalidate()
					}
				}
			case .screenshot:
				titleLabel.text = "Screenshot"
				mediaService.loadScreenshotPhotos { assets in
					let vc = StoryboardScene.RegularAssets.initialScene.instantiate()
					vc.modalPresentationStyle = .fullScreen
					vc.assets = assets
					vc.type = .screen
					DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
						self.navigationController?.pushViewController(vc, animated: true)
						self.timer.invalidate()
					}
				}
			case .duplicateVideos:
				titleLabel.text = "Duplicate videos"
				mediaService.fetchSimilarVideos { assets, duplicatesCount in
					let vc = StoryboardScene.GroupedAssets.initialScene.instantiate()
					vc.modalPresentationStyle = .fullScreen
					vc.assetGroups = assets
                    vc.duplicatesCount = duplicatesCount
					DispatchQueue.main.async {
						self.navigationController?.pushViewController(vc, animated: true)
						self.timer.invalidate()
					}
				}
			case .video:
				titleLabel.text = "Video organization"
//				photoVideoManager.loadVideos { assets in
//					self.setupMetadataForAssets(assets: assets) { metaAssets in
//						let vc = StoryboardScene.SortedAssets.initialScene.instantiate()
//						vc.modalPresentationStyle = .fullScreen
//						vc.metadataAssets = metaAssets
//						DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//							self.navigationController?.pushViewController(vc, animated: true)
//							self.timer.invalidate()
//						}
//					}
//				}
        case .some(.duplicateContacts): break
        case .some(.imcompleteContacts): break
        case .none: break
        case .some(.gif): break
        }
    }
	
	func setupMetadataForAssets(assets: [PHAsset], completion: @escaping ([MetadataAsset]) -> ()) {
		var resultArray = [MetadataAsset]()
		assets.forEach { asset in
			resultArray.append(MetadataAsset(asset: asset, name: asset.value(forKey: "filename") as? String ?? "", size: Int(asset.imageSize), date: asset.creationDate ?? Date()))
		}
		if resultArray.count == assets.count {
			completion(resultArray)
		}
	}
    
    func setCleanupOption(_ cleanupOption: CleanupOption?) {
        self.cleanupOption = cleanupOption
    }
	
	private func updateSearch() {
		if counter == 0 {
			searchLabel.text = "Search."
			counter = 1
		} else if counter == 1 {
			searchLabel.text = "Search.."
			counter = 2
		} else if counter == 2 {
			searchLabel.text = "Search..."
			counter = 0
		}
	}
}
