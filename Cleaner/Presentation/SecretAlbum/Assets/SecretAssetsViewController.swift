//
//  SecretAssetsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 30.10.2024.
//

import PhotosUI
import BottomPopup
import AVKit

final class SecretAssetsViewController: UIViewController {
    @IBOutlet weak var arrowBackView: UIView!
    @IBOutlet weak var itemsCountLabel: Regular13LabelStyle!
    @IBOutlet weak var selectionButton: SelectionButtonStyle!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var lockedStatusIcon: UIImageView!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
    @IBOutlet weak var addMediaContainer: UIView!
    @IBOutlet weak var importMediaButton: ActionToolbarButtonStyle!
    @IBOutlet weak var takeMediaButton: ActionToolbarButtonStyle!
    @IBOutlet weak var cancelButtonInAddMediaContainer: DismissButtonStyle!
    
    @IBOutlet weak var deleteOrRestoreMediaContainer: UIView!
    @IBOutlet weak var itemsForDeletionOrRestoreCountLabel: Semibold15LabelStyle!
    @IBOutlet weak var deleteButton: ActionToolbarButtonStyle!
    @IBOutlet weak var restoreButton: ActionToolbarButtonStyle!
    @IBOutlet weak var cancelButtonInDeleteOrRestoreContainer: DismissButtonStyle!
    
    private lazy var items = [SecretItemModel]() {
        didSet {
            itemsCountLabel.bind(text: "\(items.count) item\(items.count == 1 ? "" : "s")")
            deleteOrRestoreMediaContainer.isHidden = itemsForDeletionAndRestoring.isEmpty
            itemsCollectionView.reloadData()
            if items.isEmpty {
                setupEmptyState()
            } else {
                hideEmptyState()
            }
        }
    }
    
    private lazy var itemsForDeletionAndRestoring = Set<SecretItemModel>() {
        didSet {
            deleteOrRestoreMediaContainer.isHidden = itemsForDeletionAndRestoring.isEmpty
            itemsForDeletionOrRestoreCountLabel.bind(text: "Delete \(itemsForDeletionAndRestoring.count) item\(itemsForDeletionAndRestoring.count == 1 ? "" : "s")?")
            selectionButton.bind(text: itemsForDeletionAndRestoring.count == items.count ? .deselectAll : .selectAll)
            itemsCollectionView.reloadData()
        }
    }
    
    private lazy var emptyStateView: EmptyStateView? = nil
    
    private lazy var userDefaultsService = UserDefaultsService.shared
    private lazy var photoVideoManager = PhotoVideoManager.shared
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
    
    //subviews of addMediaContainer
    @IBAction func tapOnTakeMediaButton(_ sender: Any) {
        configurePicker()
    }
    
    @IBAction func tapOnImportMediaButton(_ sender: Any) {
        configureImagePicker()
    }
    
    @IBAction func tapOnCancelInAddMediaContainer(_ sender: Any) {
        addMediaContainer.isHidden = true
        addButton.isHidden = false
    }
    
    //subviews of deleteOrRestoreMediaContainer
    @IBAction func tapOnDeleteButton(_ sender: Any) {
        let vc = CleaningAssetsViewController(from: .secretAlbum, itemsCount: itemsForDeletionAndRestoring.count, items: Array(itemsForDeletionAndRestoring))
        vc.modalPresentationStyle = .currentContext
        navigationController?.pushViewController(vc, animated: false)
        itemsForDeletionAndRestoring.removeAll()
        items.removeAll()
    }
    
    @IBAction func tapOnRestoreButton(_ sender: Any) {
        photoVideoManager.saveToCameraRollFolder(Array(itemsForDeletionAndRestoring))
        itemsForDeletionAndRestoring.removeAll()
    }
    
    @IBAction func tapOnCancelInDeleteOrRestoreContainer(_ sender: Any) {
        deleteOrRestoreMediaContainer.isHidden = true
    }

    private func updateUI() {
        lockedStatusIcon.image = userDefaultsService.isPasscodeCreated && userDefaultsService.isPasscodeTurnOn ? .locked :  .unlocked
        
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
            
            if items.isEmpty {
                setupEmptyState()
            }
        } catch {
            setupEmptyState()
        }
    }

    private func showSecretAlbumCover() {
        itemsCollectionView.isHidden = true
        itemsCountLabel.bind(text: "0 items")
        selectionButton.isHidden = true
    }
    
    private func showSecretAssets() {
        addMediaContainer.isHidden = false
        addButton.isHidden = true
    }
    
    private func setupEmptyState() {
        itemsCollectionView.isHidden = true
        itemsCountLabel.bind(text: "0 items")
        selectionButton.isHidden = true
        addMediaContainer.isHidden = true
        deleteOrRestoreMediaContainer.isHidden = true
        
        emptyStateView?.removeFromSuperview()
        emptyStateView = view.createEmptyState(type: .emptySecretAlbum)
        if let emptyStateView {
            view.addSubview(emptyStateView)
        }
    }
    
    private func hideEmptyState() {
        itemsCollectionView.reloadData()
        itemsCollectionView.isHidden = false
        
        selectionButton.isHidden = false
        selectionButton.bind(text: itemsForDeletionAndRestoring.count == items.count ? .deselectAll : .selectAll)
        
        addButton.isHidden = false
        
        emptyStateView?.removeFromSuperview()
        emptyStateView = nil
    }
}

extension SecretAssetsViewController: ViewControllerProtocol {
    func setupUI() {
        itemsCollectionView.register(cellType: AssetCollectionViewCell.self)
        selectionButton.delegate = self
        setupMediaContainer()
        setupdeleteOrRestoreMediaContainer()
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
        cancelButtonInAddMediaContainer.bind(text: "Cancel")
        
        addMediaContainer.layer.cornerRadius = 20
        addMediaContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addMediaContainer.addShadows()
    }
    
    private func setupdeleteOrRestoreMediaContainer() {
        restoreButton.bind(text: "Restore", backgroundColor: .clear, textColor: .black, borderColor: .blue, borderWidth: 2.0)
        cancelButtonInDeleteOrRestoreContainer.bind(text: "Cancel")
        
        deleteOrRestoreMediaContainer.layer.cornerRadius = 20
        deleteOrRestoreMediaContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        deleteOrRestoreMediaContainer.addShadows()
    }
}

extension SecretAssetsViewController: SelectionButtonDelegate {
    func tapOnButton() {
        if itemsForDeletionAndRestoring.count == items.count {
            itemsForDeletionAndRestoring.removeAll()
        } else {
            itemsForDeletionAndRestoring.insert(items)
        }
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

extension SecretAssetsViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        addMediaContainer.isHidden = true
        addButton.isHidden = false
        
        var assetsIdentifiersForDeletion = [String]()
        
        var counter: Int = 0
        let maxCounter = results.count
        
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
                            
                            counter += 1
                            
                            if counter == maxCounter {
                                if userDefaultsService.isRemovePhotosAfterImport {
                                    photoVideoManager.delete(identifiers: assetsIdentifiersForDeletion)
                                }
                                
                                DispatchQueue.main.async { [weak self] in
                                    picker.dismiss(animated: true)
                                    self?.reloadData()
                                }
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
                        
                        counter += 1
                        
                        if counter == maxCounter {
                            if userDefaultsService.isRemovePhotosAfterImport {
                                photoVideoManager.delete(identifiers: assetsIdentifiersForDeletion)
                            }
                            
                            DispatchQueue.main.async { [weak self] in
                                picker.dismiss(animated: true)
                                self?.reloadData()
                            }
                        }
                    } catch {}
                }
            }
        }
    }
    
    private func configureImagePicker() {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.selectionLimit = 10
        configuration.filter = .any(of: [.images, .videos])
        
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        present(pickerViewController, animated: true)
    }
}

extension SecretAssetsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        addMediaContainer.isHidden = true
        addButton.isHidden = false
        
        if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            let fileName = (info[.imageURL] as? URL)?.lastPathComponent ?? UUID().uuidString
            
            do {
                try FileManager.default.saveImage(image: image, imageName: fileName, folderName: folderName)

                DispatchQueue.main.async { [weak self] in
                    picker.dismiss(animated: true)
                    self?.reloadData()
                }
            } catch {}
            
        } else if let videoURL = info[.mediaURL] as? URL {
            do {
                try FileManager.default.saveVideo(videoUrl: videoURL, folderName: folderName)
                
                DispatchQueue.main.async { [weak self] in
                    picker.dismiss(animated: true)
                    self?.reloadData()
                }
            } catch {}
        }
    }
    
    private func configurePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
}

extension SecretAssetsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AssetCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        
        let item = items[indexPath.row]
        cell.bind(image: item.mediaType == .photo ? item.image : item.videoThumbnail,
                  isChecked: itemsForDeletionAndRestoring.contains(item),
                  index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        switch item.mediaType {
        case .photo:
            guard let image = item.image else { return }
            
            let gallery = MediaCarousel()
            gallery.singleTapMode = .dismiss
            gallery.items = [MediaCarouselItem(image: image)]
            present(photoGallery: gallery)
            
        case .video:
            guard let url = item.videoUrl else { return }
            let player = AVPlayer(url: url)
            let controller = AVPlayerViewController()
            controller.player = player

            present(controller, animated: true) {
                player.play()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        TargetSize.medium.size
    }
}

extension SecretAssetsViewController: AssetCollectionViewCellDelegate {
    func tapOnCheckBox(index: Int) {
        let item = items[index]
        if itemsForDeletionAndRestoring.contains(item) {
            itemsForDeletionAndRestoring.remove(item)
        } else {
            itemsForDeletionAndRestoring.insert(item)
        }
    }
}
