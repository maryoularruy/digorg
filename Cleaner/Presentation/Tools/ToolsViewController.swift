//
//  ToolsViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 29.10.2024.
//

import UIKit

final class ToolsViewController: UIViewController {
    @IBOutlet weak var toolOptionsStackView: UIStackView!
    private lazy var secureVaultOptionToolView = ToolOptionView(.secureVault)
    private lazy var secureContactsOptionToolView = ToolOptionView(.secureContacts)
    private lazy var networkSpeedTestOptionToolView = ToolOptionView(.networkSpeedTest)
    private lazy var widgetOptionToolView = ToolOptionView(.widgets)
    private lazy var batteryOptionToolView = ToolOptionView(.battery)
    @IBOutlet weak var instructionsView: UIView!
    @IBOutlet weak var instructionsIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        updateUI()
    }
    
    private func updateUI() {
        // Все функции теперь доступны без подписки
        [secureVaultOptionToolView, secureContactsOptionToolView,
         networkSpeedTestOptionToolView, widgetOptionToolView, batteryOptionToolView].forEach { $0.unlock() }
    }
}

extension ToolsViewController: ViewControllerProtocol {
    func setupUI() {
        [secureVaultOptionToolView, secureContactsOptionToolView,
         networkSpeedTestOptionToolView, widgetOptionToolView, batteryOptionToolView].forEach { optionView in
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
        case .secureVault: StoryboardScene.SecretAssets.initialScene.instantiate()
        case .secureContacts: StoryboardScene.SecretContacts.initialScene.instantiate()
        case .networkSpeedTest: NetworkSpeedTestViewController()
        case .widgets: WidgetViewController()
        case .battery: StoryboardScene.Battery.initialScene.instantiate()
        }
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
}
