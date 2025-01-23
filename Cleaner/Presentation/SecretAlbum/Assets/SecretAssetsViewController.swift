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
    
    private lazy var items = [MediaModel]() {
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
    
    private lazy var itemsForDeletionAndRestoring = Set<MediaModel>()
    
    private lazy var emptyStateView: EmptyStateView? = nil
    private lazy var userDefaultsService = UserDefaultsService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsCollectionView.register(cellType: AssetCollectionViewCell.self)
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupUI()
        reloadData()
    }
    
    @IBAction func tapOnAddButton(_ sender: Any) {
        if userDefaultsService.isPasscodeCreated {
            if userDefaultsService.isPasscodeConfirmed {
                addMediaContainer.isHidden = false
                addButton.isHidden = true
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
    
    private func reloadData() {
        items.removeAll()
        guard let folderName = UserDefaultsService.shared.get(String.self, key: .secretAlbumFolder) else { return }
        
        do {
            let itemNames = try FileManager.default.getAll(folderName: folderName)
            itemNames.forEach { name in
                if let image = FileManager.default.getImage(imageName: name, folderName: folderName) {
                    items.append(MediaModel(with: image))
                }
            }
        } catch { return }
    }
}

extension SecretAssetsViewController: ViewControllerProtocol {
    func setupUI() {
        lockedStatusIcon.image = userDefaultsService.isPasscodeCreated ? .locked :  .unlocked
        if userDefaultsService.isPasscodeConfirmed {
            setupMediaContainer()
        }
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
        takeMediaButton.bind(text: "Take photo or video",
                             image: .takeMedia)
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
        
        results.forEach { result in
            let itemProvider = result.itemProvider
            guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
                  let utType = UTType(typeIdentifier)
            else { return }
            
            if utType.conforms(to: .image) {
                itemProvider.getPhoto { [weak self] result in
                    switch result {
                    case .success(let item):
                        guard let photo = item.photo else { return }
                        
                        do {
                            let folderName = self?.userDefaultsService.get(String.self, key: .secretAlbumFolder) ?? "media"
                            
                            try FileManager.default.saveImage(image: photo, imageName: item.id, folderName: folderName)
                            
                            DispatchQueue.main.async {
                                self?.items.append(item)
                            }
                        } catch { break }

                    case .failure(_): break }
                }
                
            } else if utType.conforms(to: .movie) {
                itemProvider.getVideo(typeIdentifier: typeIdentifier) { [weak self] result in
                    switch result {
                    case .success(let item):
                        DispatchQueue.main.async {
                            self?.items.append(item)
                        }
                    case .failure(_): break }
                }
            }
        }
        
        picker.dismiss(animated: true)
    }
    
    private func configureImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
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
        cell.photoImageView.image = items[indexPath.row].photo
        cell.isChecked = itemsForDeletionAndRestoring.contains(items[indexPath.row])
        cell.addTapGestureRecognizer {
            cell.isChecked.toggle()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        TargetSize.medium.size
    }
}
