//
//  SecretAssetsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 30.10.2024.
//

import PhotosUI
import BottomPopup

final class SecretAssetsViewController: UIViewController {
    @IBOutlet weak var arrowBackView: UIView!
    @IBOutlet weak var itemsCountLabel: Regular13LabelStyle!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addMediaContainer: UIView!
    @IBOutlet weak var lockedStatusIcon: UIImageView!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    @IBOutlet weak var importMediaButton: ActionToolbarButtonStyle!
    @IBOutlet weak var takeMediaButton: ActionToolbarButtonStyle!
    @IBOutlet weak var cancelButton: DismissButtonStyle!
    
    private lazy var items = [SecretItemModel]() {
        didSet {
            itemsCountLabel.bind(text: "\(items.count) item\(items.count == 1 ? "" : "s")")
            itemsCollectionView.reloadData()
            if items.isEmpty {
                setupEmptyState()
            } else {
                hideEmptyState()
            }
        }
    }
    
    private lazy var itemsForDeletionAndRestoring = Set<SecretItemModel>()
    
    private lazy var emptyStateView: EmptyStateView? = nil
    
    private lazy var userDefaultsService = UserDefaultsService.shared
    private lazy var folderName = userDefaultsService.get(String.self, key: .secretAlbumFolder) ?? "media"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUI()
    }
    
    deinit {
        print("SecretAssetsViewController deinit")
    }
    
    @IBAction func tapOnAddButton(_ sender: Any) {
        if userDefaultsService.isPasscodeTurnOn {
            
            if userDefaultsService.isPasscodeCreated {
                if userDefaultsService.isPasscodeConfirmed {
                    showSecretAssets()
                } else {
                    let vc = StoryboardScene.Passcode.initialScene.instantiate()
                    vc.assetsIsParentVC = true
                    vc.passcodeMode = .enter
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                guard let vc = UIStoryboard(name: ConfirmActionWithImageViewController.idenfifier, bundle: .main).instantiateViewController(identifier: ConfirmActionWithImageViewController.idenfifier) as? ConfirmActionWithImageViewController else { return }
                vc.popupDelegate = self
                vc.height = 416
                vc.type = .createPasscode
                DispatchQueue.main.async { [weak self] in
                    self?.present(vc, animated: true)
                }
            }
            
        } else {
            showSecretAssets()
        }
    }
    
    @IBAction func tapOnTakeMediaButton(_ sender: Any) {
        //TODO: -Open camera
    }
    
    @IBAction func tapOnImportMediaButton(_ sender: Any) {
        if #available(iOS 14.0, *) {
            configureImagePicker()
        } else {
            configurePicker()
        }
    }
    
    @IBAction func tapOnCancelButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func updateUI() {
        lockedStatusIcon.image = userDefaultsService.isPasscodeCreated ? .locked :  .unlocked
        
        if userDefaultsService.isPasscodeTurnOn {
            if userDefaultsService.isPasscodeConfirmed {
                reloadData()
            } else {
                showSecretAlbumCover()
            }
        } else {
            reloadData()
        }
    }
    
    private func reloadData() {
        do {
            let fileNames = try FileManager.default.getAll(folderName: folderName).sorted(by: <)
            
            fileNames.forEach { name in
                if !items.contains(where: { $0.id == name } ) {
                    if name.contains("photo") {
                        guard let image = FileManager.default.getImage(imageName: name, folderName: folderName) else { return }
                        items.append(SecretItemModel(id: name, image: image))
                        
                    } else if name.contains("video") {
                        guard let url = FileManager.default.getVideoURL(videoName: name, folderName: folderName) else { return }
                        
                        FileManager.default.getVideoThumbnail(from: url) { [weak self] thumbnail in
                            let thumbnail = thumbnail ?? #imageLiteral(resourceName: "gif")
                            
                            self?.items.append(SecretItemModel(id: name, videoUrl: url, videoThumbnail: thumbnail))
                        }
                    }
                }
            }
        } catch { return }
    }

    private func showSecretAlbumCover() {
        itemsCollectionView.isHidden = true
        itemsCountLabel.bind(text: "0 items")
    }
    
    private func showSecretAssets() {
        addMediaContainer.isHidden = false
        addButton.isHidden = true
    }
    
    private func setupEmptyState() {
        itemsCollectionView.isHidden = true
        itemsCountLabel.bind(text: "0 items")
        emptyStateView?.removeFromSuperview()
        emptyStateView = view.createEmptyState(type: userDefaultsService.isPasscodeConfirmed ? .emptySecretAlbumConfirmed : .emptySecretAlbum)
        if let emptyStateView {
            view.addSubview(emptyStateView)
        }
    }
    
    private func hideEmptyState() {
        itemsCollectionView.reloadData()
        itemsCollectionView.isHidden = false
        emptyStateView?.removeFromSuperview()
        emptyStateView = nil
    }
}

extension SecretAssetsViewController: ViewControllerProtocol {
    func setupUI() {
        itemsCollectionView.register(cellType: AssetCollectionViewCell.self)
        setupMediaContainer()
    }
    
    func addGestureRecognizers() {
        arrowBackView.addTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }
    
    private func setupMediaContainer() {
        takeMediaButton.bind(text: "Take photo or video", image: .takeMedia)
        importMediaButton.bind(text: "Import photo or video",
                               backgroundColor: .acidGreen,
                               textColor: .black,
                               image: .importMedia)
        cancelButton.bind(text: "Cancel")
        
        addMediaContainer.layer.cornerRadius = 20
        addMediaContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addMediaContainer.addShadows()
    }
}

extension SecretAssetsViewController: BottomPopupDelegate {
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        if newValue == 100 {
            let vc = StoryboardScene.Passcode.initialScene.instantiate()
            vc.passcodeMode = .create
            vc.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

@available(iOS 14.0, *)
extension SecretAssetsViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        addMediaContainer.isHidden = true
        addButton.isHidden = false
        
        var assetsIdentifiersForDeletion = [String]()
        
        results.forEach { result in
            let itemProvider = result.itemProvider
            guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
                    let utType = UTType(typeIdentifier) else { return }
            
            let assetIdentifier = result.assetIdentifier
            
            if utType.conforms(to: .image) {
                itemProvider.getPhoto { image in
                    guard let image else { return }
                    itemProvider.getFileName(typeIdentifier: UTType.image.identifier) { [weak self] fileName in
                        guard let self, let fileName else { return }
                        
                        do {
                            try FileManager.default.saveImage(image: image, imageName: fileName, folderName: folderName)
                            
                            if let assetIdentifier {
                                assetsIdentifiersForDeletion.append(assetIdentifier)
                            }
                        } catch {}
                    }
                }
                
            } else if utType.conforms(to: .movie) {
                itemProvider.getVideoURL(typeIdentifier: UTType.movie.identifier) { [weak self] url in
                    guard let self, let url else { return }
                    
                    do {
                        try FileManager.default.saveVideo(videoUrl: url, folderName: folderName)
                        
                        if let assetIdentifier {
                            assetsIdentifiersForDeletion.append(assetIdentifier)
                        }
                    } catch {}
                }
            }
        }
        
        picker.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            reloadData()
            
            if userDefaultsService.isRemovePhotosAfterImport {
                let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetsIdentifiersForDeletion, options: nil)
                var assets = [PHAsset]()
                fetchResult.enumerateObjects { asset, _, _  in
                    assets.append(asset)
                }
                PhotoVideoManager.shared.delete(assets: assets)
            }
        }
    }
    
    private func configureImagePicker() {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.selectionLimit = 0
        configuration.filter = .any(of: [.images, .videos])
        
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
}

extension SecretAssetsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            print("Selected image: \(selectedImage)")
        } else if let selectedVideoURL = info[.mediaURL] as? URL {
            print("Selected video URL: \(selectedVideoURL)")
        }
        
        picker.dismiss(animated: true)
    }
    
    private func configurePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
//        picker.mediaTypes = ["public.image", "public.movie"]
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
}

extension SecretAssetsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AssetCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let item = items[indexPath.row]
        
        cell.photoImageView.image = item.mediaType == .photo ? item.image : item.videoThumbnail
        cell.isChecked = itemsForDeletionAndRestoring.contains(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as? AssetCollectionViewCell)?.isChecked.toggle()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        TargetSize.medium.size
    }
}
