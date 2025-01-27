//
//  InstructionsMenuViewController.swift
//  Cleaner
//
//  Created by Elena Sedunova on 14.11.2024.
//

import UIKit

final class InstructionsMenuViewController: UIViewController {
    @IBOutlet weak var arrowBackView: UIView!
    @IBOutlet weak var instructionsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureRecognizers()
    }
    
    deinit {
        print("InstructionsViewController deinit")
    }
}

extension InstructionsMenuViewController: ViewControllerProtocol {
    func setupUI() {
        InstructionCellType.allCases.forEach { type in
            let view = InstructionCell()
            view.delegate = self
            view.bind(type)
            instructionsStackView.addArrangedSubview(view)
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
}

extension InstructionsMenuViewController: InstructionCellDelegate {
    func tapOnCell(_ type: InstructionCellType) {
        let vc: UIViewController = switch type {
        case .safariCache: SafariCacheViewController()
        case .telegramCache: TelegramCacheViewController()
        case .offloadUnusedApps: UnusedAppsOffloadViewController()
        case .optimizeViberMedia: ViberOptimizeViewController()
        case .whatsAppCleanup: WhatsAppCleanupViewController()
        }
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true)
    }
}
