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
    }
    
    func addGestureRecognizers() {
         
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
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
}
