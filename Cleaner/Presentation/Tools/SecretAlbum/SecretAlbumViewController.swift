//
//  SecretAlbumViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 30.10.2024.
//

import UIKit
import Photos
import BottomPopup

final class SecretAlbumViewController: UIViewController {
    @IBOutlet weak var arrowBackView: UIView!
    @IBOutlet weak var itemsCountLabel: Regular13LabelStyle!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addMediaContainer: UIView!
    @IBOutlet weak var lockedStatusIcon: UIImageView!
    @IBOutlet weak var importMediaButton: ActionToolbarButtonStyle!
    @IBOutlet weak var takeMediaButton: ActionToolbarButtonStyle!
    @IBOutlet weak var cancelButton: DismissButtonStyle!
    
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
    
    private var isPasscodeCreated: Bool {
        userDefaultsService.get(String.self, key: .secretAlbumPasscode) != nil
    }
    
    private var isPasscodeConfirmed: Bool {
        userDefaultsService.get(Bool.self, key: .secretPasscodeConfirmed) == true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        items = []
        setupUI()
    }
    
    @IBAction func tapOnAddButton(_ sender: Any) {
        if isPasscodeCreated {
            let vc = StoryboardScene.Passcode.initialScene.instantiate()
            vc.passcodeMode = .enter
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(vc, animated: true)
        } else {
            guard let vc = UIStoryboard(name: ConfirmActionWithImageViewController.idenfifier, bundle: .main).instantiateViewController(identifier: ConfirmActionWithImageViewController.idenfifier) as? ConfirmActionWithImageViewController else { return }
            vc.bind(popupDelegate: self, type: .createPasscode, height: 416, actionButtonText: "Create Passcode")
            DispatchQueue.main.async { [weak self] in
                self?.present(vc, animated: true)
            }
        }
    }
    
    private func setupEmptyState() {
        itemsCountLabel.bind(text: "0 items")
        emptyStateView?.removeFromSuperview()
        emptyStateView = view.createEmptyState(type: isPasscodeConfirmed ? .emptySecretAlbumConfirmed : .emptySecretAlbum)
        if let emptyStateView {
            view.addSubview(emptyStateView)
        }
    }
    
    @IBAction func tapOnTakeMediaButton(_ sender: Any) {
        //TODO: -Open camera
    }
    
    @IBAction func tapOnImportMediaButton(_ sender: Any) {
        openImagePicker()
    }
    
    @IBAction func tapOnCancelButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension SecretAlbumViewController: ViewControllerProtocol {
    func setupUI() {
        lockedStatusIcon.image = isPasscodeCreated ? .locked :  .unlocked
        if isPasscodeConfirmed {
            setupMediaContainer()
            addButton.isHidden = true
            addMediaContainer.isHidden = false
        } else {
            addButton.isHidden = false
            addMediaContainer.isHidden = true
        }
    }
    
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupMediaContainer() {
        takeMediaButton.bind(text: "Take photo or video",
                             image: .takeMedia)
        importMediaButton.bind(text: "Import photo or video",
                               backgroundColor: .acidGreen,
                               textColor: .blackText,
                               image: .importMedia)
        cancelButton.bind(text: "Cancel")
        
        addMediaContainer.layer.cornerRadius = 20
        addMediaContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addMediaContainer.addShadows()
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
        
        picker.dismiss(animated: true) {
            
        }
    }
    
    private func openImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .savedPhotosAlbum //depricated, use PHPickerViewController instead
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
}
