//
//  NetworkService.swift
//  Cleaner
//
//  Created by Elena Sedunova on 10.02.2025.
//

import Foundation

final class NetworkService {
    static var shared = NetworkService()
    
    func measureDownloadSpeed(completion: @escaping (Double?) -> Void) {
        guard let url = URL(string: "https://link.testfile.org/PDF10MB") else {
            completion(nil)
            return
        }
        
        let startTime = Date()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let elapsedTime = Date().timeIntervalSince(startTime)
            let speedInMbps = (Double(data.count)) * 8 / (elapsedTime * 1_000_000)
            
            DispatchQueue.main.async {
                completion(speedInMbps)
            }
        }
        
        task.resume()
    }
    
    func measurePing(completion: @escaping (Double?) -> Void) {
        guard let url = URL(string: "https://dns.google/resolve?name=google.com") else {
            completion(nil)
            return
        }
        
        let startTime = Date().timeIntervalSince1970
        
        let task = URLSession.shared.dataTask(with: url) { _, response, error in
            guard error == nil, let _ = response as? HTTPURLResponse else {
                completion(nil)
                return
            }
            
            let endTime = Date().timeIntervalSince1970
            let pingInMs = (endTime - startTime) * 1000
            DispatchQueue.main.async {
                completion(pingInMs)
            }
        }
        
        task.resume()
    }
}
