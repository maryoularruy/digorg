//
//  SecretAlbumViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 30.10.2024.
//

import PhotosUI
import BottomPopup

final class SecretAlbumViewController: UIViewController {
    @IBOutlet weak var arrowBackView: UIView!
    @IBOutlet weak var itemsCountLabel: Regular13LabelStyle!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addMediaContainer: UIView!
    @IBOutlet weak var lockedStatusIcon: UIImageView!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    @IBOutlet weak var importMediaButton: ActionToolbarButtonStyle!
    @IBOutlet weak var takeMediaButton: ActionToolbarButtonStyle!
    @IBOutlet weak var cancelButton: DismissButtonStyle!
    
    private lazy var items: [MediaModel] = [] {
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
    
    private var isPasscodeCreated: Bool {
        userDefaultsService.get(String.self, key: .secretAlbumPasscode) != nil
    }
    
    private var isPasscodeConfirmed: Bool {
        userDefaultsService.get(Bool.self, key: .secretPasscodeConfirmed) == true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if isPasscodeCreated {
            itemsCollectionView.register(cellType: PhotoCollectionViewCell.self)
        }
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupUI()
    }
    
    @IBAction func tapOnAddButton(_ sender: Any) {
        if isPasscodeCreated {
            if isPasscodeConfirmed {
                addMediaContainer.isHidden = false
                addButton.isHidden = true
            } else {
                let vc = StoryboardScene.Passcode.initialScene.instantiate()
                vc.passcodeMode = .enter
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                navigationController?.pushViewController(vc, animated: true)
            }

        } else {
            guard let vc = UIStoryboard(name: ConfirmActionWithImageViewController.idenfifier, bundle: .main).instantiateViewController(identifier: ConfirmActionWithImageViewController.idenfifier) as? ConfirmActionWithImageViewController else { return }
            vc.bind(popupDelegate: self, type: .createPasscode, height: 416, actionButtonText: "Create Passcode")
            DispatchQueue.main.async { [weak self] in
                self?.present(vc, animated: true)
            }
        }
    }
    
    @IBAction func tapOnTakeMediaButton(_ sender: Any) {
        //TODO: -Open camera
    }
    
    @IBAction func tapOnImportMediaButton(_ sender: Any) {
        configureImagePicker()
    }
    
    @IBAction func tapOnCancelButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func setupEmptyState() {
        itemsCollectionView.isHidden = true
        itemsCountLabel.bind(text: "0 items")
        emptyStateView?.removeFromSuperview()
        emptyStateView = view.createEmptyState(type: isPasscodeConfirmed ? .emptySecretAlbumConfirmed : .emptySecretAlbum)
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

extension SecretAlbumViewController: ViewControllerProtocol {
    func setupUI() {
        lockedStatusIcon.image = isPasscodeCreated ? .locked :  .unlocked
        if isPasscodeConfirmed {
            setupMediaContainer()
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

extension SecretAlbumViewController: PHPickerViewControllerDelegate {
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
                        DispatchQueue.main.async {
                            self?.items.append(item)
                        }
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

extension SecretAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.photoImageView.image = items[indexPath.row].photo
        cell.isChecked = itemsForDeletionAndRestoring.contains(items[indexPath.row])
        cell.addTapGestureRecognizer {
            cell.isChecked.toggle()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 109, height: 109)
    }
}
