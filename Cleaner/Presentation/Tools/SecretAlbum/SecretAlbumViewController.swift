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
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var lockedStatusIcon: UIImageView!
    
    private lazy var items: [PHAsset] = [] {
        didSet {
            itemsCountLabel.bind(text: "\(items.count) item\(items.count == 1 ? "" : "s")")
            addButton.isHidden = !items.isEmpty
            if items.isEmpty {
                setupEmptyState()
            } else {
                emptyStateView = nil
            }
        }
    }
    
    private lazy var emptyStateView: EmptyStateView? = nil
    private lazy var userDefaultsService = UserDefaultsService.shared
    
    private var isPasswordCreated: Bool {
        userDefaultsService.get(String.self, key: .secretAlbumPassword) != nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
        items = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lockedStatusIcon.image = isPasswordCreated ? .locked :  .unlocked
    }
    
    @IBAction func tapOnAddButton(_ sender: Any) {
        
    }
    
    private func setupEmptyState() {
        emptyStateView = view.createEmptyState(type: .emptySecretAlbum)
        if let emptyStateView {
            view.addSubview(emptyStateView)
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
