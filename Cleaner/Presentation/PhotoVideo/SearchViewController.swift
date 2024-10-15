//
//  SearchViewController.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 19.05.2022.
//

import Lottie
import UIKit
import Photos

final class SearchViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var searchLabel: UILabel!
    
    private let mediaService = MediaService.shared
    private var cleanupOption: CleanupOption?
    
	private lazy var timer = Timer()
	private lazy var counter = 0
//	@IBOutlet var animationView: AnimationView!
    
	override func viewDidLoad() {
        super.viewDidLoad()
//		animationView.animation = Animation.named("Search")
//		animationView.play(fromProgress: 0, toProgress: 1, loopMode: .loop, completion: nil)
        timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true, block: { [weak self] _ in
            self?.updateSearch()
        })
        
        guard let cleanupOption else { return }
		switch cleanupOption.mode {
			case .duplicatePhotos:
				titleLabel.text = "Duplicate"
				mediaService.loadSimilarPhotos(live: false) { assetGroups, duplicatesCount in
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
				mediaService.loadLivePhotos { assets in
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
				mediaService.loadSelfiePhotos { assets in
					let vc = StoryboardScene.RegularAssets.initialScene.instantiate()
					vc.modalPresentationStyle = .fullScreen
					vc.assets = assets
					vc.type = .selfie
					DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
						self.navigationController?.pushViewController(vc, animated: true)
						self.timer.invalidate()
					}
				}
			case .gif:
				titleLabel.text = "Gif"
				mediaService.loadGifPhotos { assets in
					let vc = StoryboardScene.RegularAssets.initialScene.instantiate()
					vc.modalPresentationStyle = .fullScreen
					vc.assets = assets
					vc.type = .gif
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
			case .duplicateVideo:
				titleLabel.text = "Duplicate"
				mediaService.loadSimilarVideos { assets in
					let vc = StoryboardScene.GroupedAssets.initialScene.instantiate()
					vc.modalPresentationStyle = .fullScreen
					vc.assetGroups = assets
					DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
						self.navigationController?.pushViewController(vc, animated: true)
						self.timer.invalidate()
					}
				}
			case .video:
				titleLabel.text = "Video organization"
//				mediaService.loadVideos { assets in
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
			case .none:
				break
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
