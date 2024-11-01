//
//  SecretAlbumViewController.swift
//  Cleaner
//
//  Created by f f on 30.10.2024.
//

import UIKit
import Photos
import BottomPopup

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
        addGestureRecognizers()
        items = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lockedStatusIcon.image = isPasswordCreated ? .locked :  .unlocked
    }
    
    @IBAction func tapOnAddButton(_ sender: Any) {
        if isPasswordCreated {
            
        } else {
            guard let vc = UIStoryboard(name: ConfirmActionWithImageViewController.idenfifier, bundle: .main).instantiateViewController(identifier: ConfirmActionWithImageViewController.idenfifier) as? ConfirmActionWithImageViewController else { return }
            vc.bind(popupDelegate: self, type: .createPasscode, height: 416, actionButtonText: "Create Passcode")
            DispatchQueue.main.async { [weak self] in
                self?.present(vc, animated: true)
            }
        }
    }
    
    private func setupEmptyState() {
        emptyStateView = view.createEmptyState(type: .emptySecretAlbum)
        if let emptyStateView {
            view.addSubview(emptyStateView)
        }
    }
}

extension SecretAlbumViewController: ViewControllerProtocol {
    func setupUI() {}
    
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension SecretAlbumViewController: BottomPopupDelegate {
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        if newValue == 100 {
            let vc = StoryboardScene.Passcode.initialScene.instantiate()
            vc.passcodeMode = .create
            vc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SecretAlbumViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
             fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            let imgName = imgUrl.lastPathComponent
            let data = image.jpegData(compressionQuality: 1)! as Data
        }
        
        picker.dismiss(animated: true) {}
    }
    
    private func openImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .savedPhotosAlbum //depricated, use PHPickerViewController instead
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: { })
    }
}
