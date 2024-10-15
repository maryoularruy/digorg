//
//  PHAssetGroup.swift
//  Cleaner
//
//  Created by Александр Пономарёв on 27.05.2022.
//

import Photos

struct PHAssetGroup: Differentiable {
	var name: String
	var assets: [PHAsset]
    var subtype: PHAssetCollectionSubtype

    init(name: String, assets: [PHAsset], subtype: PHAssetCollectionSubtype) {
		self.name = name
		self.assets = assets
        self.subtype = subtype
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
