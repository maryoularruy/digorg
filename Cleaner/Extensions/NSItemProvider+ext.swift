//
//  NSItemProvider+ext.swift
//  Cleaner
//
//  Created by Elena Sedunova on 01.11.2024.
//

import UIKit

extension NSItemProvider {
    func getPhoto(completion: @escaping (Result<MediaModel, Error>) -> ()) {
        if self.canLoadObject(ofClass: UIImage.self) {
            self.loadObject(ofClass: UIImage.self) { object, error in
                if let error { completion(.failure(error)) }

                if let image = object as? UIImage {
                    completion(.success(MediaModel(with: image)))
                }
            }
        }
    }
    
    func getVideo(typeIdentifier: String, completion: @escaping (Result<MediaModel, Error>) -> ()) {
        self.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
            if let error { completion(.failure(error)) }

            guard let url else { return }
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            guard let targetURL = documentsDirectory?.appendingPathComponent(url.lastPathComponent) else { return }

            do {
                if FileManager.default.fileExists(atPath: targetURL.path) {
                    try FileManager.default.removeItem(at: targetURL)
                }
                try FileManager.default.copyItem(at: url, to: targetURL)
                completion(.success(MediaModel(with: targetURL)))
            } catch { completion(.failure(error)) }
        }
    }
}
