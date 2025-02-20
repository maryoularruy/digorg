//
//  ToolsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 29.10.2024.
//

import UIKit

final class ToolsViewController: UIViewController {
    @IBOutlet weak var premiumImageView: UIImageView!
    
    @IBOutlet weak var toolOptionsStackView: UIStackView!
    private lazy var secretAlbumOptionToolView = ToolOptionView(.secretAlbum)
    private lazy var secretContactsOptionToolView = ToolOptionView(.secretContact)
    private lazy var networkSpeedTestOptionToolView = ToolOptionView(.networkSpeedTest)
    private lazy var batteryOptionToolView = ToolOptionView(.battery)
    
    @IBOutlet weak var instructionsView: UIView!
    @IBOutlet weak var instructionsIcon: UIImageView!
    
    private lazy var userDefaultsService = UserDefaultsService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func updateUI() {
        let isSubscriptionActive = userDefaultsService.isSubscriptionActive
        
        premiumImageView.isHidden = !isSubscriptionActive
        
        if isSubscriptionActive {
            [secretAlbumOptionToolView, secretContactsOptionToolView].forEach { $0.unlock() }
        } else {
            [secretAlbumOptionToolView, secretContactsOptionToolView].forEach { $0.setLocked() }
        }
    }
}

extension ToolsViewController: ViewControllerProtocol {
    func setupUI() {
        [secretAlbumOptionToolView, secretContactsOptionToolView,
         networkSpeedTestOptionToolView, batteryOptionToolView].forEach { optionView in
            optionView.delegate = self
            toolOptionsStackView.addArrangedSubview(optionView)
        }
        
        instructionsIcon.layer.cornerRadius = 20
        instructionsIcon.layer.maskedCorners = [.layerMaxXMaxYCorner]
        
        instructionsView.layer.cornerRadius = 20
        instructionsView.addShadows()
    }
    
    func addGestureRecognizers() {
        instructionsView.addTapGestureRecognizer { [weak self] in
            let vc = StoryboardScene.Instructions.initialScene.instantiate()
            vc.modalPresentationStyle = .fullScreen
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ToolsViewController: ToolOptionViewDelegate {
    func tapOnOption(_ option: ToolOption) {
        let vc = switch option {
        case .secretAlbum: StoryboardScene.SecretAssets.initialScene.instantiate()
        case .secretContact: StoryboardScene.SecretContacts.initialScene.instantiate()
        case .networkSpeedTest: NetworkSpeedTestViewController()
//        case .widgets:
//            StoryboardScene.SecretAlbum.initialScene.instantiate()
        case .battery: StoryboardScene.Battery.initialScene.instantiate()
        }
        userDefaultsService.remove(key: .isPasscodeConfirmed)
        vc.modalPresentationStyle = .fullScreen
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
