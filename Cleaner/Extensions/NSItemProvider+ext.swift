//
//  NSItemProvider+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 01.11.2024.
//

import UIKit

extension NSItemProvider {
    func getFileName(typeIdentifier: String, completion: @escaping (String?) -> Void) {
        loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, _ in
            guard let url else {
                completion(nil)
                return
            }
            
            completion(url.lastPathComponent)
        }
    }
    
    func getPhoto(completion: @escaping (UIImage?) -> Void) {
        if canLoadObject(ofClass: UIImage.self) {
            loadObject(ofClass: UIImage.self) { object, error in
                if error == nil, let image = object as? UIImage {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    func getVideoURL(typeIdentifier: String, completion: @escaping (URL?) -> Void) {
        loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, _ in
            guard let videoURL = url else {
                completion(nil)
                return
            }
            
            completion(videoURL)
        }
    }
}
