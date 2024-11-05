//
//  MediaModel.swift
//  Cleaner
//
//  Created by Elena Sedunova on 04.11.2024.
//

import UIKit
import Photos

struct MediaModel: Identifiable, Hashable {
    enum MediaType {
        case photo, video, livePhoto
    }

    var id: String
    var photo: UIImage?
    var url: URL?
    var livePhoto: PHLivePhoto?
    var mediaType: MediaType = .photo
    
    init(with photo: UIImage) {
        id = UUID().uuidString
        self.photo = photo
        mediaType = .photo
    }
    
    init(with videoURL: URL) {
        id = UUID().uuidString
        url = videoURL
        mediaType = .video
    }

    init(with livePhoto: PHLivePhoto) {
        id = UUID().uuidString
        self.livePhoto = livePhoto
        mediaType = .livePhoto
    }
}
