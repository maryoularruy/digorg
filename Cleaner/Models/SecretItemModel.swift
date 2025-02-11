//
//  SecretItemModel.swift
//  Cleaner
//
//  Created by Elena Sedunova on 04.11.2024.
//

import UIKit
import Photos

struct SecretItemModel: Identifiable, Hashable {
    enum MediaType {
        case photo, video
    }
    
    var id: String
    var mediaType: MediaType
    
    var image: UIImage?
    var videoUrl: URL?
    var videoThumbnail: UIImage?
    
    init(id: String, image: UIImage) {
        mediaType = .photo
        self.id = id
        self.image = image
    }
    
    init(id: String, videoUrl: URL, videoThumbnail: UIImage) {
        mediaType = .video
        self.id = id
        self.videoUrl = videoUrl
        self.videoThumbnail = videoThumbnail
    }
}
