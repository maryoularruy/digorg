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
	
	var differenceIdentifier: String {
		name
	}
	
	func isContentEqual(to source: PHAssetGroup) -> Bool {
		source.name == name
	}
}

struct MetadataAsset: Differentiable, Equatable {
	func isContentEqual(to source: MetadataAsset) -> Bool {
		date == source.date
	}
	
	var asset: PHAsset
	var name: String
	var size: Int
	var date: Date
	
	var differenceIdentifier: Date {
		date
	}
}
