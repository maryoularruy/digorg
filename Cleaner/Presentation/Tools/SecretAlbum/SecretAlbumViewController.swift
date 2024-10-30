//
//  SecretAlbumViewController.swift
//  Cleaner
//
//  Created by f f on 30.10.2024.
//

import UIKit
import Photos

final class SecretAlbumViewController: UIViewController {
    @IBOutlet weak var arrowBackView: UIView!
    @IBOutlet weak var itemsCountLabel: Regular13LabelStyle!
    
    private lazy var items: [PHAsset] = [] {
        didSet {
            itemsCountLabel.bind(text: "\(items.count) item\(items.count == 1 ? "" : "s")")
        }
    }
    
}

extension SecretAlbumViewController: ViewControllerProtocol {
    func setupUI() {
        
    }
    
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
