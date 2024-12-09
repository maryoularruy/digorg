//
//  OneCategoryModel.swift
//  Cleaner
//
//  Created by Elena Sedunova on 09.12.2024.
//

import Photos
import UIKit

protocol OneCategoryProtocol: AnyObject, UIView {
    var type: Any { get }
    var assets: [PHAsset] { get }
}

enum OneCategory {
    enum HorizontalViewType {
        case similarPhotos, duplicatePhotos, portraits, allPhotos,
        duplicateVideos, superSizedVideos, allVideos
        
        var title: String {
            switch self {
            case .similarPhotos: "Similar Photos"
            case .duplicatePhotos: "Duplicate Photos"
            case .portraits: "Portraits"
            case .allPhotos: "All Photos"
            case .duplicateVideos: "Duplicate Videos"
            case .superSizedVideos: "Super-sized Video"
            case .allVideos: "All Videos"
            }
        }
    }
    
    enum RectangularViewType {
        case live, blurry
        
        var title: String {
            switch self {
            case .live: "Live"
            case .blurry: "Blurry"
            }
        }
    }
    
    enum VerticalViewType {
        case screenshots
        
        var title: String {
            switch self {
            case .screenshots: "Screenshots"
            }
        }
    }
}
