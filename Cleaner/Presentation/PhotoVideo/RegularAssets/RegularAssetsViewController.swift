//
//  RegularAssetsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 04.12.2024.
//

import UIKit

enum RegularAssetsType {
    case livePhotos, blurryPhotos, portraits, screenshots, allPhotos, superSizedVideos, allVideos
    
    var title: String {
        switch self {
        case .livePhotos: "Live Photo"
        case .blurryPhotos: "Blurry"
        case .portraits: "Portraits"
        case .screenshots: "Screenshots"
        case .allPhotos: "All Photos"
        case .superSizedVideos: "Super-sized Video"
        case .allVideos: "All Videos"
        }
    }
}

final class RegularAssetsViewController: UIViewController {
    private lazy var rootView = RegularAssetsView(type)
    
    private lazy var photoVideoManager = PhotoVideoManager.shared
    private var type: RegularAssetsType
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    init(type: RegularAssetsType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
