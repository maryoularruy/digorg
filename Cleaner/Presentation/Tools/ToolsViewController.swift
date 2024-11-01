//
//  ToolsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 29.10.2024.
//

import UIKit

final class ToolsViewController: UIViewController {
    @IBOutlet weak var proImageView: UIImageView!
    @IBOutlet weak var toolOptionsStackView: UIStackView!
    @IBOutlet weak var instructionsView: UIView!
    @IBOutlet weak var instructionsIcon: UIImageView!
    
    private lazy var userDefaultsService = UserDefaultsService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
}

extension ToolsViewController: ViewControllerProtocol {
    func setupUI() {
        ToolOption.allCases.forEach { option in
            let view = ToolOptionView()
            view.delegate = self
            view.bind(option)
            toolOptionsStackView.addArrangedSubview(view)
        }
        
        instructionsIcon.layer.cornerRadius = 20
        instructionsIcon.layer.maskedCorners = [.layerMaxXMaxYCorner]
        
        instructionsView.layer.cornerRadius = 20
        instructionsView.addShadows()
    }
    
    func addGestureRecognizers() {
        instructionsView.addTapGestureRecognizer { [weak self] in
            let vc = StoryboardScene.SecretAlbum.initialScene.instantiate()
            vc.modalPresentationStyle = .fullScreen
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ToolsViewController: ToolOptionViewDelegate {
    func tapOnOption(_ option: ToolOption) {
        let vc = switch option {
        case .secretAlbum: StoryboardScene.SecretAlbum.initialScene.instantiate()
        case .secretContact:
            StoryboardScene.SecretAlbum.initialScene.instantiate()
        case .networkSpeedTest:
            StoryboardScene.SecretAlbum.initialScene.instantiate()
        case .widgets:
            StoryboardScene.SecretAlbum.initialScene.instantiate()
        case .battery:
            StoryboardScene.SecretAlbum.initialScene.instantiate()
        }
        userDefaultsService.remove(key: .secretPasscodeConfirmed)
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
}
