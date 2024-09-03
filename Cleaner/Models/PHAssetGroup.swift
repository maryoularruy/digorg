//
//  PHAssetGroup.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 27.05.2022.
//

import Photos
import UIKit

class PHAssetGroup: Differentiable {
	var name: String
	var assets: [PHAsset]

	init(name: String, assets: [PHAsset]) {
		self.name = name
		self.assets = assets
	}
	
	var differenceIdentifier: String {
		return name
	}
	
	func isContentEqual(to source: PHAssetGroup) -> Bool {
		return source.name == name
	}
}

struct MetadataAsset: Differentiable, Equatable {
	func isContentEqual(to source: MetadataAsset) -> Bool {
		return date == source.date
	}
	
	var asset: PHAsset
	var name: String
	var size: Int
	var date: Date
	
	var differenceIdentifier: Date {
		return date
	}
}

